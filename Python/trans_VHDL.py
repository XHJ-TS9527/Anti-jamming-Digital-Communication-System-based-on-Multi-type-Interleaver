def transfer_VHDL(filename):
    file=open('%s.csv'%filename,'rt')
    content=file.readlines()
    file.close()
    each_map=[]
    for each in content:
        each=each.replace('\n','')
        each=each.split(',')
        target_address=each[2]
        origin_CNT=each[3]
        each_map.append('"%s" when "%s",\n'%(target_address,origin_CNT))
    if '伪随机' in filename:
        temp_string=((content[0].replace('\n','')).split(','))[2]
    else:
        temp_string='00000000'
    each_map.append('"%s" when others;'%temp_string)
    file=open('%s_VHDL.csv'%filename,'wt')
    file.writelines(each_map)
    file.close()

def main():
    interweave_mode=('块','对角','伪随机','螺旋','奇偶','反射','交指','回旋')
    for each in interweave_mode:
        transfer_VHDL('%s交织地址映射'%each)

if __name__=='__main__':
    main()