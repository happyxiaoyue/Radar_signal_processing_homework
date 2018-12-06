clear
tic
%�Ӳ��������
N = 16;                        % ��Ԫ����
M = 8;                        % ���������
CNR = 30;                      % �����
beta = 1;                      % �Ӳ��۵�ϵ��(beta = 2*v*T/d)
sita_a = -90:.9:90.;         % �Ӳ���Ԫ����   
c=3e8;
f0=1.2e9;
lamda=c/f0;
d=lamda/2;
v=100;
sita = sita_a*pi/180;
[NN N_bin] = size(sita);
%Ŀ�����
sita_t = -25;                  % Ŀ��DOA
omiga_t = 0.4;                 % Ŀ��Doppler
SNR = 0;                       % �����

%�ռ䵼��ʸ����ʱ�䵼��ʸ��
%�ռ�Ƶ�ʺ�DoppleƵ������ omiga_d = beta * omiga_s
omiga_s = pi*sin(sita);      
omiga_d = beta*omiga_s;       

aN = zeros(N,N_bin);
bN = zeros(M,N_bin);

aN = exp(-j*[0:N-1]'*omiga_s)./sqrt(N);
bN = exp(-j*[0:M-1]'*omiga_d)./sqrt(M);


%Ŀ���ʱ�ź�
aN_t = zeros(N,1);
bN_t = zeros(M,1);

aN_t = exp(-j*pi*[0:N-1]'*sin(sita_t*pi/180))/sqrt(N);
bN_t = exp(-j*pi*[0:M-1]'*omiga_t)/sqrt(M);

S_t = zeros(M*N,1);
S_t = kron(aN_t,bN_t);

%�����Ӳ�Э�������
R = zeros(M*N,M*N);                     
S = zeros(M*N,N_bin);                   
ksai = 10^(CNR/10)*(randn(1,N_bin)+j*randn(1,N_bin))/sqrt(2);               %������̬�ֲ��������ֵ������Ϊ1
for ii = 1:N_bin
    S(:,ii) = kron(aN(:,ii),bN(:,ii));  
    R = R + ksai(ii).*(S(:,ii)*S(:,ii)');       
end

%����Э������������Ϊ30dB
R = R +eye(M*N);     %CNR = 30dB
inv_R = inv(R);                   %�����
P_min_var = zeros(N_bin,N_bin);
%���Ӳ���
for ii = 1:N_bin
    for jj = 1:N_bin
            SS = kron(aN(:,ii),bN(:,jj));
            P_min_var(ii,jj) = 1./(SS'*inv_R*SS);
    end
end        

%��С�������
figure(1)
mesh(sin(sita),omiga_d/pi,20*log10(abs(P_min_var)));
title('��Ԫ��N=16, ���������M=8');
xlabel('��λ����');
ylabel('��һ��DoppleƵ��');
zlabel('����(dB)');
grid on
%��ʱ����Ȩ����
w_opt = inv(R)*S_t./(S_t'*inv_R*S_t);   
%w_opt = inv(RR)*a_t;

%�����ſ�ʱ��Ӧ
for ii = 1:N_bin
    for jj = 1:N_bin
        SSS = kron(aN(:,ii),bN(:,jj));
        res_opt(ii,jj) = SSS'*w_opt;
    end
end
                      
figure(3)
%[X,Y]=meshgrid(omiga_d/pi,sita_a);
mesh(omiga_d/pi,omiga_d/pi,10*log10(abs(res_opt).^2))
title('��Ԫ��N=16, ���������M=8');
xlabel('��һ��DoppleƵ��');
ylabel('��λ����');
zlabel('����(dB)');
grid on