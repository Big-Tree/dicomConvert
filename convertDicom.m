 % Only work for specific directory structure

%   -------Required Structure-------
% Converts all the files in the given directory (dirSourc)
% and outputs the images to dirData


%dirSource = '/vol/vssp/mammo2/Will_Murphy/DATA/labeled/training/0_1/0_dicom/*.dcm' % Files to be converted
%dirSource = '/user/HS204/wm0015/student/testImage/*'; % Directory containing all the Dicom images
%dirData = '/user/HS204/wm0015/student/out/';
dirSource = '/scratch/real/dcm/malignant/*'; % Directory containing all the Dicom images
dirData = '/scratch/real/tiff/matlab/malignant/';
allFiles = dir(dirSource);



count = 0;
% Remove current and previous directory (. ..)
allFiles(1) = [];
allFiles(1) = [];
imageCounter = 0;
numberOfImages = 1;

% Find number of images
numberOfImages = length(allFiles);
fprintf('%i images found\n', numberOfImages);



fprintf('\nWriting %i images\n', numberOfImages);
% Write backgrounds for test
tic
lastTime = 0;
for i = 1:numberOfImages
    imagePath = [allFiles(i).folder, '/', allFiles(i).name];
    [dicomFile, map] = dicomread(imagePath);
    %disp(["max = " max(max(dicomFile))]); % Find bit depth        
    correctedImage = uint16(16383 * mat2gray(dicomFile) ); %Increase the contrast by 12 times
    %imshow(correctedImage);    
    [fPath, fName, fExt] = fileparts(allFiles(i).name); 
    newFile = [dirData, fName, '.tiff'];
    imwrite(correctedImage, newFile, 'tiff');
    
    progressReportFrequency = 50;
    if mod(i, progressReportFrequency) == 0
        progress = i/numberOfImages;
        fprintf('%%%.0f - ', progress*100);
        rate = (toc-lastTime)/progressReportFrequency;   
        timeLeft = rate*(numberOfImages-i);
        fprintf('%.1f seconds elapsed - %.1f seconds left\n', toc, timeLeft);        
        lastTime = toc;
    end
end



fprintf('\n---Complete---\n');