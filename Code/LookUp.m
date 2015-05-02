SampleSize=1024;
SampleRate=10e6;
NBits=8;
Amplitude=2^NBits/2-1;
x=0:(2*pi)/SampleSize:2*pi-(2*pi)/SampleSize;
%A=Amplitude*cos(x)+Amplitude*cos(5*x)+Amplitude*cos(10*x)+Amplitude*cos(15*x)+Amplitude*cos(20*x)+Amplitude*cos(25*x)+Amplitude*cos(30*x)+Amplitude*cos(35*x)+Amplitude*cos(40*x)+Amplitude*cos(45*x)+Amplitude*cos(50*x)+Amplitude*cos(55*x)+Amplitude*cos(60*x)+Amplitude*cos(65*x)+Amplitude*cos(70*x)+Amplitude*cos(75*x)+Amplitude*cos(80*x)+Amplitude*cos(85*x)+Amplitude*cos(90*x)+Amplitude*cos(95*x)+Amplitude*cos(100*x);

A=Amplitude*cos(x);
for j = 10:10:500;
	A=A+Amplitude*cos(j*x);
endfor

%norm=(max(A)+abs(min(A)))/255;

%Find the normalization factor
%We need to get the whole spectrum between -127 and 127
%therfore the normalization factor is 1 div by the smllest negative value
%or the highest positive value
tmp(1)=max(A);
tmp(2)=abs(min(A));
norm=max(tmp)/127;

A=A./norm;
%A=A.+abs(min(A));


for j = 1:length(A);
	A(j)=round(A(j));
endfor



figure(1)
plot(x,A);

figure(2)
FFTSize=2048;
FFT_Signal=fft(A,FFTSize);
Real_Signal=FFT_Signal(1:FFTSize/2);
plot(0:SampleRate/(FFTSize):(SampleRate/2)-1/FFTSize,abs(Real_Signal));
for i=1:SampleSize
printf ("%d	=>\"%s\",\n",i-1,dec2bin(typecast(int16(A(i)),'uint16'),NBits));
endfor;
