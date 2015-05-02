function AnalyseData

A=dlmread("out_values.txt");
FFTSize=2048;

figure(1)
plot(A(:,1),A(:,2));
saveas (1, "Filter_TimeInput.png");
figure(2)
plot(A(:,1),A(:,3));
saveas (1, "Filter_TimeOutput.png");
figure(3);
myFFT2=fft(A(:,2),FFTSize);
Real2=myFFT2(1:FFTSize/2);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(Real2));
saveas (1, "Filter_FFTInput.png");
figure(4);
myFFT=fft(A(:,3),FFTSize);
Real=myFFT(1:FFTSize/2);
plot(0:0.5/(FFTSize/2):0.5-0.5/(FFTSize/2),abs(Real));
saveas (1, "Filter_FFTOutput.png");

endfunction
