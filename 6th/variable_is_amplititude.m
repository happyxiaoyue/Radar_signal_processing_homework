clear;
T=10e-6;    %���Ե�Ƶ�ź�����
B=30e6;     %���Ե�Ƶ�źŴ���
K=B/T;      %��Ƶ��
Fs=2*B;     %�����������ο�˹�ض���
Ts=1/Fs;    %�������
N=T/Ts;     %��������
t=linspace(-T/2,T/2,N);
St=exp(j*pi*K*t.^2);
Ht=exp(-j*pi*K*t.^2);
s_out=ifftshift(ifft(fft(St,N).*fft(Ht,N),N));
ii=1;
for A=[0.5,1,1.5,2]
delta_t=1.5/B;
n=delta_t/Ts;%������
t2=linspace(-T/2+delta_t,T/2+delta_t,N);
St2=exp(j*pi*K*(t2-delta_t).^2);
Ht2=exp(-j*pi*K*(delta_t-t2).^2);
s_out2=ifftshift(ifft(fft(St2,N).*fft(Ht2,N),N))*A;
NN=N+n;
for i=1:1:NN
    if i<= n
        s(i)=real(s_out(i));
    else
        if i>N
            s(i)=real(s_out2(i-n));
        else
            s(i)=real(s_out(i))+real(s_out2(i-n));
        end
    end
end
i=linspace(1,NN,NN);
switch ii
    case 1
        subplot(4,1,1);
        title('ʱ�Ӳ�Ϊ1.5*1/B����һ�������ֵΪǰһ����0.5');
        hold on;
    case 2
        subplot(4,1,2);
        title('ʱ�Ӳ�Ϊ1.5*1/B�������ֵ���');
        hold on;
    case 3
        subplot(4,1,3);
        title('ʱ�Ӳ�Ϊ1.5*1/B����һ�������ֵΪǰһ����1.5');
        hold on;
    otherwise
        subplot(4,1,4);
        title('ʱ�Ӳ�Ϊ1.5*1/B����һ�������ֵΪǰһ����2.0');
        hold on;
end
ii=ii+1;
plot(i,s);
grid on;
axis([1,NN,-300,1000]);
xlabel('ʱ��');
ylabel('��ֵ');
end