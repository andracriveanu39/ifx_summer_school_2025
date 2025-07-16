#!/usr/bin/env python
import os
import argparse
import subprocess


def main():
  args = parse_arguments()
  set_env_variables()
  cmd = build_cmd(args)
  subprocess.run(cmd, shell= True)


def parse_arguments():
  arg_parser = argparse.ArgumentParser()
  arg_parser.add_argument('-mode', required = True, choices =['sim', 'imc'], help = 'Choose between running SimVision or IMC')
  arg_parser.add_argument('-test', required = False, help = 'Provide name of UVM_TEST')
  arg_parser.add_argument('-seed', required = False, default = 0, help = 'Provide SV seed for test')
  arg_parser.add_argument('-batch', action ='store_true', required = False, help = 'Start simulation in batch mode')
  args = arg_parser.parse_args()

  if args.mode == 'sim' and args.test == None:
    print("A testname must be provided for running UVM based simulation!")
    os._exit(-1)

  return args


def set_env_variables():
  os.environ['MDV_XLM_HOME'] = '/opt/cadence/installs/XCELIUM2309'
  set_project_root()


def set_project_root():
  proj_root = os.getcwd()
  proj_root = proj_root.removesuffix('/simulation/sv_sim')
  os.environ['proj_root'] = proj_root


def build_cmd(args):
  cmd = str()

  if args.mode == 'sim':
    cmd = '/opt/cadence/installs/XCELIUM2409/tools/xcelium/bin/xrun '
    cmd += '+UVM_TESTNAME={test} -svseed {seed} '.format(test = args.test, seed = args.seed)
    if args.batch:
      cmd += '-batch '
    else:
      cmd += '-gui '
    cmd += '-f run.args &'
  else:
     cmd = '/opt/cadence/installs/VMANAGER2309/bin/imc'

  return cmd 


if __name__ == '__main__':
  main()
