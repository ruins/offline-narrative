% Personal Narrative Clip filter
% ---
% Pull data from narrative JSON files into MATLAB variables
% and looks for "good" and "bad" photos
% Uses JSONlab:
% http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?jsonlab/Doc

% -----
% USAGE
% -----
% json_path should point to the \meta folder
% I highly recommend running the code a cell at a time (%% delimited) as
% is is probably not bug free :)


% TODO Image Rotate
% TODO pull more good/bad params from image processing. Look for bad
% exposure, blocked images etc

%% Init
clear all, close all; clc;

json_path = 'E:\narrative\2014\06\05\meta';

all_files = dir([json_path  '/'  '*.json']);

json_count = length(all_files);

mag = zeros(json_count, 3);
acc = zeros(json_count, 3);
bat = zeros(json_count, 1);
lig = zeros(json_count, 1);
avg = zeros(json_count, 1);
img16 = zeros(json_count, 16);
trigger = false(json_count, 1);     % True if photo was manually triggered
raw_num = zeros(json_count, 1);

%% Reading from files

for i = 1:json_count
    fname = all_files(i).name;
    data = loadjson([json_path '/' fname]);
    
    disp(fname);
    
    % Number from filename - not timestamp (it would seem...)
    raw_num(i) = str2num(fname(1:end-5)); %#ok<ST2NM>
    
    mag(i, :) = (data.mag_data.samples)';
    acc(i, :) = (data.acc_data.samples)';
    bat(i) = data.bat_level;
    lig(i) = data.light_meter;
    avg(i) = data.avg_readout;
    img16(i, :) = (data.avg_win)';
    
    % Not taken with timer --> manually triggered
    if strcmpi((data.trigger), 'timer') == 0
        trigger(i) = true;
    end
end

%% Looking for "good" and "bad" images
% Finding blurry images
acc_mag = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
mag_mag = sqrt(mag(:,1).^2 + mag(:,2).^2 + mag(:,3).^2);

acc_tolerance = 0.05;       % +- Range of "good" accelerations rel gravity
acc_g = median(acc_mag);    % Estimate of gravity
good_acc = acc_g * [1-acc_tolerance, 1+acc_tolerance];
blurry_idx = acc_mag < good_acc(1) & acc_mag > good_acc(2);
blurry_num = raw_num(blurry_idx);

% Too dark - no information in image
min_avg = 10;                   % Range 0 - 255
min_img16_std = min_avg / 3;    % 3 stdev from avg
min_lig = 10;                   % Range = ??? TODO find out!

img16_std = std(img16, 0, 2);
dark_idx = (lig < min_lig | avg < min_avg) & img16_std < min_img16_std;
dark_num = raw_num(dark_idx);

% Manually triggered _but_ not too dark or blurry
fav_num = raw_num(trigger & ~blurry_idx & ~dark_idx);

%% Show sensor data
figure;
plot(raw_num, bat, '.');
title('Battery');

figure;
plot(raw_num, lig, '.');
title('Light Sensor');

figure;
plot(raw_num, avg, '.');
title('Average Readout');

figure;
plot(raw_num, acc_mag, '.');
title('Acceleration Magnitude');

figure;
plot(raw_num, acc(:,1), 'r.');
hold on
plot(raw_num, acc(:,2), 'gx');
plot(raw_num, acc(:,3), 'b*');
hold off
title('Acceleration XYZ');
legend('x', 'y', 'z');

figure;
plot(raw_num, mag_mag, '.');
title('Magnetometer Magnitude');

figure;
plot(raw_num, mag(:,1), 'r.');
hold on
plot(raw_num, mag(:,2), 'gx');
plot(raw_num, mag(:,3), 'b*');
hold off
title('Magnetometer XYZ');
legend('x', 'y', 'z');

%% TODO - File operations to delete images etc
fprintf('\n\n');
disp('Favourites (not blurry or dark)')
fprintf('%06d.jpg\n', fav_num)
fprintf('\n\n');
disp('Blurry and/or Dark images - Delete?')
fprintf('%06d.jpg\n', raw_num(blurry_idx | dark_idx));

