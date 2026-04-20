import pandas as pd
import subprocess

def run_sv_test(index,test_name,seed_number):
    """running SV project test"""
    command = ["vcs","-sverilog","-debug_access+all","-full64","-R","+incdir+/home/dvft1004/system_verilog/apb_project/verification/apb_agent/",
               "+incdir+/home/dvft1004/system_verilog/apb_project/verification/apb_environment/",
               "+incdir+/home/dvft1004/system_verilog/apb_project/verification/apb_env_pkg.svp/",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_base_test/",
               "+incdir+/home/dvft1004/system_verilog/apb_project/verification/apb_tb_top/",
               "+incdir+/home/dvft1004/system_verilog/apb_project/design/",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_agent/apb_agent_pkg.svp",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_environment/apb_env_pkg.svp",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_base_test/apb_write_test.sv",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_base_test/apb_read_test.sv",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_base_test/apb_pslverr.sv",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_base_test/apb_write_read.sv",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_tb_top/apb_top.sv",
               "/home/dvft1004/system_verilog/apb_project/verification/apb_tb_top/apb_interface.sv",
               "/home/dvft1004/system_verilog/apb_project/design/apb_slave_design.sv",
               "+ntb_random_seed={}".format(seed_number),
               "-cm","line+cond+fsm+tgl+branch+assert",
               "-cm_dir","{}_coverage.vdb".format(test_name),"-l",
               "{}.log".format(test_name)]
    if(index<5):
        print("executing command with wait: {}".format(' '.join(command)))
        result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    else:
        print("executing command: {}".format(' '.join(command1)))
        result=subprocess.run(command1,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    
    print("STDOUT:",result.stdout.decode())
    print("STDERR:",result.stderr.decode())
      if(result.returncode==0):
        print("Test {} complete successfully".format(test_name))
    else:
        print("Test {} failed with error \n{}".format(test_name,stderr.decode()))

def main():
    print("start the regression")
    ods_file='/home/dvft1004/system_verilog/apb_project/run/apb_test.ods'
    try:
        df=pd.read_excel(ods_file,engine='odf')
        print("Loaded data from {}".format(ods_file))
        if(df.empty):
            print("the data frame is empty please check ods file")
            return
        print("Data Frame contents: \n",df)

    except Exception as e:
        print("Error,Loading ODS file:{}".format(e))
        return

    for index,row in df.iterrows():
        serial_no,test_name,run_flag,seed_number=row
        print("processing row:{}, Test name: {}, Run Flag: {}".format(index,test_name,run_flag))
        if(run_flag==1):
            run_sv_test(index,test_name,seed_number)
        else:
            print("skipping test:{} (Run flag:{})".format(test_name,run_flag))

if __name__ == "__main__":
    main()
