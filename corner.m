clc;
clear;
close all;

%% Input Image
I = checkerboard(100,4,4); % Input 8-by-8 checker board image

figure(1)
imshow(I)
title('Input Checkerboard Image','FontSize',14);

%% Ground Truth of Corners
cnt = 1;
for i = 1:7
    for j = 1:7
        gt(cnt,1)=i*100;
        gt(cnt,2)=j*100;
        cnt=cnt+1;
    end
end
%% Performance Evaluation
min_qualities = [0.15 0.3 0.45];
for j = 1:3
for i = 1:50
rng(2);                                                           % random seed
J = imnoise(I,'gaussian',0,0.001*i);                               % Gaussian noise addition 
corners = detectMinEigenFeatures(J,'MinQuality',min_qualities(j));  % Corner Detection
cor_loc = fix(corners.Location);
s = 0;
catched = 0;
for i1 = 1:49
    s = s+min(sum(abs([gt(i1,1) gt(i1,2)]-cor_loc).^2,2));
    if min(sum(abs([gt(i1,1) gt(i1,2)]-cor_loc).^2,2))==0
        catched = catched+1;
    end
end
rmse(i)= s/49;
cor_num= length(cor_loc);
missed(i)= 49-catched;
spurious(i)= cor_num-catched;
end
figure(1+j)
subplot(3,1,1)
plot([1:50]*0.001,rmse,'r--','LineWidth',2);
xlabel('Variance of Gaussian Noise');
ylabel('RMSE');
title("RMSE vs Gaussian noise variance minimum quality = "+string(min_qualities(j)));
grid minor;
subplot(3,1,2)
plot([1:50]*0.001,missed,'r--','LineWidth',2);
xlabel('Variance of Gaussian Noise');
ylabel('Number of Missed Corner');
title("Number of Missed Corner vs Gaussian noise variance for minimum quality = "+string(min_qualities(j)));
grid minor
subplot(3,1,3)
plot([1:50]*0.001,spurious,'r--','LineWidth',2);
xlabel('Variance of Gaussian Noise');
ylabel('Number of Spurious Corner');
title("Number of Spurious Corner vs Gaussian noise variance for minimum quality = "+string(min_qualities(j)));
grid minor
end


