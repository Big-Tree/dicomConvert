% Works for 13 bit images.  Alter line 43 for different bit depths

% Set paths
dicomPath = uigetdir('', 'Select location of DICOM images');
outputPath = uigetdir('', 'Select destination for converted images');
outputPath = [outputPath, '/'];
dicomPath = [dicomPath, '/*'];
allFiles = dir(dicomPath);


dirData = '/scratch/real/tiff/matlab/malignant/';
class(dirData)
class(outputPath)
disp(dirData)
disp(outputPath)
%return
% Set output image format
imageFormat = inputdlg('Enter output image format (tiff, png, bmp etc...)', 'Image format', [1,50]);
fprintf('Image format: .%s\n', imageFormat{:})


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
    correctedImage = uint16(16383 * mat2gray(dicomFile) ); % 13 bit depth
    %imshow(correctedImage);    
    [fPath, fName, fExt] = fileparts(allFiles(i).name); 
    newFile = [outputPath, fName, '.', imageFormat{:}];
    imwrite(dicomFile, newFile, imageFormat{:});
    
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



fprintf('Images written to %s\n---Complete---\n', outputPath);