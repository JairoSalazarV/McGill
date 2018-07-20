load('fisheriris');
y = meas(:,1);
X = [ones(size(y,1),1),meas(:,2:4)];

regf=@(trainX,trainY,validX,validY,parameters)(runModel(trainX,trainY,validX,validY,parameters));

cvMse = crossval(regf, [])