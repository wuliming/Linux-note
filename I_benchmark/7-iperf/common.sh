SERVER_IP="193.168.140.157"
CLIENT_IP="193.168.140.8"
GUEST_TEST=0  # 1|0  1: start iperf on guest; 0:start iperf on native
PWD=`pwd`
TEST_DIR="$PWD"
SHELL_DIR="$PWD/shell"
RPM_DIR="$TEST_DIR/rpm"
CHECK_DIR="$TEST_DIR/../set_env"
LOG_DIR="$TEST_DIR/log"

IRQBALANCE=0  # 0|1 1:on  | 0:off
ROUND=1
PORT=12345
BIND_CPU=1    # 0|1 1:bind | 0:nobind  
TIME=20
INTERVAL=2
LENTH="32"
TAZYU="1 "


