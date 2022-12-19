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


def main(scheduler, dudez_path="DOCKING_GRIDS_AND_POSES", run_script_path="../../run.sh", timeout_seconds_between_targets=None):
    #
    try:
        _ = SCHEDULER_NAME_TO_CLASS_DICT[scheduler]()  # TODO: actually use Scheduler class
    except KeyError:
        raise Exception(
            f"The following environmental variables are required to use the {scheduler} job scheduler: {SCHEDULER_NAME_TO_CLASS_DICT[scheduler].REQUIRED_ENV_VAR_NAMES}"
        )

    #
    dudez_path = Path(dudez_path)
    dir_paths = [Path(x).absolute() for x in os.listdir(dudez_path) if os.path.isdir(x)]
    for dir_path in dir_paths:
        if scheduler == "slurm":
            command_str = f"{os.environ['SBATCH_EXEC']} --time=0 --signal=B:USR1@120 --array=1-1 {run_script_path}"
        elif scheduler == "sge":
            command_str = f"{os.environ['QSUB_EXEC']} -v TARGET_DIR={dir_path} -t 1-1 {run_script_path}"
        else:
            raise Exception(f"`scheduler` must be one of: {SCHEDULERS}")
        env_vars_dict={
            "TARGET_DIR": str(dir_path)
        }
        print(dir_path)
        proc = subprocess.run(
            command_str,
            cwd=dir_path,
            shell=True,
            env=env_vars_dict,
        )
        print(proc.stdout)
        print(proc.stderr)
        if timeout_seconds_between_targets:
            time.sleep(timeout_seconds_between_targets)

if __name__ == '__main__':
    fire.Fire(main)

