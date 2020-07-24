function seq=m_sequence(coef)
    m=length(coef);
    len=2^m-1;
    seq=zeros(1,len);
    registers=[1 zeros(1, m-2) 1];
    for idx=1:len
        seq(idx)=registers(m);
        backQ=mod(sum(coef.*registers),2);
        registers(2:length(registers))=registers(1:length(registers)-1);
        registers(1)=backQ;
    end
end