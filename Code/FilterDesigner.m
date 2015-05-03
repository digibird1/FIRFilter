%(c) by Daniel Pelikan 2015
%This code designs the Lowpass or a High pass filter poles
% which can be used in the vhdl code for a digital FIR filter
% sinc filter with Blackman window 

function FilterDesigner

CutOffFreq=25;%change in Hz, max 1/2 of teh sample frequency
SampleRate=1000;%Sample Rate
%Bandwidth of the filter
BW=0.2;%Change
MakeHighPass=0; %0 Low pass, 1 High Pass
FilterGain=5; % default is "1" gain can be used to compensate the negative gain during interpolation

%Length of filter Kernel
M=round(4/BW)+1;

Filter=zeros(1,M);

%Normalized cutoff frequency
FC=CutOffFreq/SampleRate

%Cut off frequency change for High pass
if(MakeHighPass==1)
	FC=0.5-FC;
endif

%Calculate the Filter Kernel
for a = 1:M
  	if ((a)-M/2==0)
  		Filter(a)=2*pi*FC;
	else
  		Filter(a)=sin(2*pi*FC*((a)-M/2))/((a)-M/2);
	endif
	%Blackman window
	Filter(a)=Filter(a)*(0.42-0.5*cos(2*pi*(a)/M)+0.08*cos(4*pi*(a)/M));
endfor




%Normalize the Filter
Sum=0;
for i = 1:M
	Sum=Sum+Filter(i);
endfor

for i = 1:M
	Filter(i)=FilterGain*Filter(i)/Sum;
endfor

%Convert filter from low pass to high pass
if(MakeHighPass==1)
%change the sign of each sample in the filter kernel
%add 1 to the filter element in the center
%Filter=-1*Filter;
%floor(M/2)
%Filter(floor(M/2))=Filter(floor(M/2))+1;

%change every sencond sign to make the filter a high pass
	for a = 1:2:M
	  	Filter(a)=-1*Filter(a);
	endfor

endif;


figure(1);

subplot(3,1,1);
plot(1:M,Filter);
grid on;
title ("Filter Kernel");
%xlabel ("Samples");
ylabel ("Amplitude");
subplot(3,1,2);
FFTSize=2048;
myFFT2=fft(Filter,FFTSize);

Real=myFFT2(1:FFTSize/2);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(Real));
grid on;
title ("Filter Performance (Norm frequency)");
%xlabel ("Samples");
ylabel ("lin Amplitude");

subplot(3,1,3);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),20*log10(abs(Real)));
grid on;
title ("Filter Performance (Norm frequency)");
%xlabel ("Samples");
ylabel ("log Amplitude [dB]");
saveas (1, "FilterDesigner_Filter.png");



%Print the Filter Kernel List as VHDL
%0     =>to_sfixed (3.125, g_fixInt-1,-1*g_fixDec)

for i = 1:M
	printf ("%d	=>to_sfixed (%f, g_fixInt-1,-1*g_fixDec),\n",i-1,Filter(i));
endfor


return;
%------------------------------------------------------------------------------------

%%Test the filter
Size=10000;
x=0:Size;
A=sin(2*pi*1*x/SampleRate);
for i=2:50
	A=A+sin(2*pi*i*x/SampleRate);
endfor

figure(2);
subplot(2,1,1);
FFT_SIGNAL=fft(A,FFTSize);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(FFT_SIGNAL(1:FFTSize/2)));


B=0;
%Convolution with output side algorithm
for j = M:Size
	B(j)=0;
	for i=1:M
		B(j)=B(j)+A(j-i+1)*Filter(i);
	endfor
endfor

subplot(2,1,2);
FFT_SIG_Filtered=fft(B,FFTSize);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(FFT_SIG_Filtered(1:FFTSize/2)));
saveas (1, "FilterDesigner_FilteredOutputSideAlgo.png");

%Convolution with input side algorithm
for j = 1:Size+length(Filter);
	C(j)=0;
endfor

for j = 1:Size
	for i=0:M-1
		C(j+i)=C(j+i)+A(j)*Filter(i+1);
	endfor
endfor

%Remove the first 31 samples sicne they are not compleatly filtered
D=C(length(Filter)+1:Size+length(Filter));

figure(3);
FFT_D_Filtered=fft(D,FFTSize);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(FFT_D_Filtered(1:FFTSize/2)));
saveas (1, "FilterDesigner_FilteredInputSideAlgo.png");

length(A)
length(B)
length(C)
length(D)

endfunction
