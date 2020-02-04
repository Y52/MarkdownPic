##需被修改文件绝对路径示例
#TARGET_INTEGRATOR_FILE="/Library/Ruby/Gems/2.6.0/gems/cocoapods-1.8.4/lib/cocoapods/installer/user_project_integrator/target_integrator.rb"
#POD_TARGET_FILE="/Library/Ruby/Gems/2.6.0/gems/cocoapods-1.8.4/lib/cocoapods/target/pod_target.rb"

##获取路径参数输入
TARGET_INTEGRATOR_FILE=$1
POD_TARGET_FILE=$2

if [[ ! -f "$TARGET_INTEGRATOR_FILE" || ! -f "$POD_TARGET_FILE" ]]
then
    ##查找文件,以找到的第一个文件为准，若版本不准确手动输入文件路径参数
    echo "finding files"
    TARGET_INTEGRATOR_FILE=`find /Library/Ruby/Gems -iname "target_integrator.rb" | head -1`
    POD_TARGET_FILE=`find /Library/Ruby/Gems -iname "pod_target.rb" | head -1`
fi

echo $TARGET_INTEGRATOR_FILE
echo $POD_TARGET_FILE

##找到两行代码位置
echo "modifying code"
TARGET_INTEGRATOR_LINE=`grep -nm 1 "MAX_INPUT_OUTPUT_PATHS" $TARGET_INTEGRATOR_FILE | awk -F : '{print $1}'`
POD_TARGET_LINE=`grep -nm 1 "next\sif\sheader.to_s.include.*framework.*" $POD_TARGET_FILE | awk -F : '{print $1}'`

##修改代码
#sed -i '' "${TARGET_INTEGRATOR_LINE}s/1000/200/g" $TARGET_INTEGRATOR_FILE
#sed -i '' "${POD_TARGET_LINE}s/next/#next/g" $POD_TARGET_FILE

echo "done"
##恢复代码
sed -i '' "${TARGET_INTEGRATOR_LINE}s/200/1000/g" $TARGET_INTEGRATOR_FILE
sed -i '' "${POD_TARGET_LINE}s/#*next/next/g" $POD_TARGET_FILE
