clc;
clear all;
close all;

s = rng(211);
numFFT = 1024;
numGuards = 212;
K = 4;
numSymbols = 100;
bitsPerSubCarrier = 2;
snrdB = 12;

# Prototype filter
switch K
  case 2
    HkOneSided = sqrt(2)/2;
  case 3
    HkOneSided = [0.911438 0.411438];
  case 4
    HkOneSided = [0.971960 sqrt(2)/2 0.235147];
  otherwise
    return
end

Hk = [fliplr(HkOneSided) 1 HkOneSided];
L = numFFT-2*numGuards;
KF = K*numFFT;
KL = K*L;

dataSubCar = zeros(L, 1);
dataSubCarUp = zeros(KL, 1);
sumFBMCSpec = zeros(KF*2, 1);
sumOFDMSpec = zeros(numFFT*2, 1);
numBits = bitsPerSubCarrier*L/2;
inpData = zeros(numBits, numSymbols);
rxBits = zeros(numBits, numSymbols);
txSigAll = complex(zeros(KF, numSymbols));
symBuf = complex(zeros(2*KF, 1));

for symIdx = 1:numSymbols
  inpData(:, symIdx) = randi([0 1], numBits, 1);
  modData = qammod(inpData(:, symIdx), 2^bitsPerSubCarrier,'InputType', 'Bit','UnitAveragePower', true);
  if rem(symIdx,2)==1
    # Odd symbols
    dataSubCar(1:2:L) = real(modData);
    dataSubCar(2:2:L) = 1i*imag(modData);
  else 
    # Even symbols
    dataSubCar(1:2:L) = 1i*imag(modData);
    dataSubCar(2:2:L) = real(modData);
  end

  dataSubCarUp(1:K:end) = dataSubCar;
  dataBitsUpPad = [zeros(numGuards*K,1); dataSubCarUp; zeros(numGuards*K,1)];
  X1 = filter(Hk, 1, dataBitsUpPad);
  X = [X1(K:end); zeros(K-1,1)];

  # Compute IFFT of length KF for the transmitted symbol
  txSymb = fftshift(ifft(X));
  symBuf = [symBuf(numFFT/2+1:end); complex(zeros(numFFT/2,1))];
  symBuf(KF+(1:KF)) = symBuf(KF+(1:KF)) + txSymb;

  # Compute power spectral density (PSD)
  currSym = complex(symBuf(1:KF));
  [specFBMC, fFBMC] = periodogram(currSym, hann(KF, 'periodic'), KF*2, 1);
  sumFBMCSpec = sumFBMCSpec + specFBMC;

  # Store transmitted signals for all symbols
  txSigAll(:,symIdx) = currSym;
end

# Plot power spectral density
sumFBMCSpec = sumFBMCSpec/mean(sumFBMCSpec(1+K+2*numGuards*K:end-2*numGuards*K-K));
plot(fFBMC-0.5,10*log10(sumFBMCSpec));
grid on
axis([-0.5 0.5 -180 10]);
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['FBMC, K = ' num2str(K) ' overlapped symbols'])
set(gcf, 'Position', figposition([15 50 30 30]));
for symIdx = 1:numSymbols
  inpData2 = randi([0 1], bitsPerSubCarrier*L, 1);
  modData = qammod(inpData2, 2^bitsPerSubCarrier, 'InputType', 'Bit', 'UnitAveragePower', true);
  symOFDM = [zeros(numGuards,1); modData; zeros(numGuards,1)];
  ifftOut = sqrt(numFFT).*ifft(ifftshift(symOFDM));
  [specOFDM,fOFDM] = periodogram(ifftOut, rectwin(length(ifftOut)),numFFT*2, 1,'centered');
  sumOFDMSpec = sumOFDMSpec + specOFDM;
end

# Plot power spectral density (PSD) over all subcarriers
sumOFDMSpec = sumOFDMSpec/mean(sumOFDMSpec(1+2*numGuards:end-2*numGuards));
figure;
plot(fOFDM,10*log10(sumOFDMSpec));
grid on
axis([-0.5 0.5 -180 10]);
xlabel('Normalized frequency');
ylabel('PSD (dBW/Hz)')
title(['OFDM, numFFT = ' num2str(numFFT)])
set(gcf, 'Position', figposition([46 50 30 30]));
BER = comm.ErrorRate;
for symIdx = 1:numSymbols
  rxSig = txSigAll(:, symIdx);
  rxNsig = awgn(rxSig, snrdB, 'measured');
  rxf = fft(fftshift(rxNsig));
  rxfmf = filter(Hk, 1, rxf);
  rxfmf = [rxfmf(K:end); zeros(K-1,1)];
  # Remove guards
  rxfmfg = rxfmf(numGuards*K+1:end-numGuards*K);
  if rem(symIdx, 2)
    # Imaginary part is K samples after real one
    r1 = real(rxfmfg(1:2*K:end));
    r2 = imag(rxfmfg(K+1:2*K:end));
    rcomb = complex(r1, r2);
  else
    # Real part is K samples after imaginary one
    r1 = imag(rxfmfg(1:2*K:end));
    r2 = real(rxfmfg(K+1:2*K:end));
    rcomb = complex(r2, r1);
  end
  rcomb = (1/K)*rcomb;
  rxBits(:, symIdx) = qamdemod(rcomb, 2^bitsPerSubCarrier,'OutputType', 'bit', 'UnitAveragePower', true);
end

BER.ReceiveDelay = bitsPerSubCarrier*KL;
ber = BER(inpData(:), rxBits(:));
disp(['FBMC Reception for K = ' num2str(K) ', BER = ' num2str(ber(1)) ' at SNR = '
num2str(snrdB) ' dB'])
rng(s);
