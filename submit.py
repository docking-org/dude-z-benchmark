import shutil
import os
from pathlib import Path
import subprocess

import fire
from pydock3.job_schedulers import SlurmJobScheduler, SGEJobScheduler


SCHEDULERS = ["slurm", "sge"]

SCHEDULER_NAME_TO_CLASS_DICT = {
    "sge": SGEJobScheduler,
    "slurm": SlurmJobScheduler,
}


def main(run_script_path, scheduler, dudez_path="DOCKING_GRIDS_AND_POSES", job_timeout_minutes=None, params_str=None, source_script_path=None, timeout_seconds_between_targets=None, target=None):
    #
    run_script_path = os.path.abspath(run_script_path)

    #
    try:
        _ = SCHEDULER_NAME_TO_CLASS_DICT[scheduler]()  # TODO: actually use Scheduler class
    except KeyError:
        raise Exception(
            f"The following environmental variables are required to use the {scheduler} job scheduler: {SCHEDULER_NAME_TO_CLASS_DICT[scheduler].REQUIRED_ENV_VAR_NAMES}"
        )

    #
    if params_str is None:
        params_str = ""
    if source_script_path is None:
        source_script_path = ""

    #
    dudez_path = Path(dudez_path)
    if target is not None:
        dir_paths = [Path(os.path.join(dudez_path, target)).absolute()]
    else:
        dir_paths = [Path(os.path.join(dudez_path, x)).absolute() for x in os.listdir(dudez_path)]
    for dir_path in dir_paths:
        target_name = os.path.basename(dir_path)
        job_name = f"dockopt_{target_name}"
        if scheduler == "slurm":
            if job_timeout_minutes is not None:
                timeout_arg_str = f"--time={job_timeout_minutes}"
            else:
                timeout_arg_str = "--time=0"  # no timeout
            command_str = f"{os.environ['SBATCH_EXEC']} --job-name={job_name} --export=TARGET_DIR='{dir_path}',SCHEDULER='{scheduler}',PARAMS='{params_str}',SOURCE_SCRIPT='{source_script_path}' {timeout_arg_str} --array=1-1 --partition=tldr {run_script_path}"
        elif scheduler == "sge":
            if job_timeout_minutes is not None:
                job_timeout_seconds = 60 * job_timeout_minutes
                timeout_arg_str = f"-l s_rt={job_timeout_seconds} -l h_rt={job_timeout_seconds}"
            else:
                timeout_arg_str = ""
            command_str = f"{os.environ['QSUB_EXEC']} -N {job_name} -v TARGET_DIR='{dir_path}' -v SCHEDULER='{scheduler}' -v PARAMS='{params_str}' -v SOURCE_SCRIPT='{source_script_path}' {timeout_arg_str} -t 1-1 {run_script_path}"
        else:
            raise Exception(f"`scheduler` must be one of: {SCHEDULERS}")
        print(dir_path)
        proc = subprocess.run(
            command_str,
            cwd=dir_path,
            shell=True,
        )
        print(f"stdout:\n{proc.stdout}\n")
        print(f"stderr:\n{proc.stderr}\n")
        if timeout_seconds_between_targets:
            time.sleep(timeout_seconds_between_targets)

if __name__ == '__main__':
    fire.Fire(main)

