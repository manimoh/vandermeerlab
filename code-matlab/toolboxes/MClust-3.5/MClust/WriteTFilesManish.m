% Script to Write Specific Cluster as TFiles

global MClust_TTdn MClust_TTfn MClust_TText
global MClust_FeatureTimestamps MClust_FeatureSources
global MClust_Clusters
clusters = MClust_Clusters;
basefn = fullfile(MClust_TTdn, MClust_TTfn);
    
nClust = length(clusters);

% Set iC to the cluster number that you want to write
iC = 1; % Set this to the cluster to be exported
oC = 1; % Set this as the suffix for the .t file 
DisplayProgress(iC, nClust, 'Title', 'Writing T files');
f = FindInCluster(clusters{iC});
if ~isempty(f)
  TS = MClust_FeatureTimestamps(f);
  fn = [basefn '_' num2str(oC) '.t'];
  fp = fopen(fn, 'wb', 'b');
  if (fp == -1)
     errordlg(['Could not open file"' fn '".']);
  end
  WriteHeader(fp, 'T-file', 'Output from MClust''Time of spiking stored in timestamps (tenths of msecs)', 'as unsigned integer');
  fwrite(fp, TS, 'uint64');
  fclose(fp);
end
% Also create the CQ file
temp_fn = split(fn,'\');
Create_CQ_File('fc',temp_fn(end), 'encoding', '64',  'species', 'M', 'allwaveforms', 1)
OK = true;