function [info,tbl]=load_BIDS_JSON(filename)

[filepath,name,ext] = fileparts(filename);
rootname = strcat(filepath, "/", name);
jsonfile=strcat(rootname, ".json");
tsvfile=strcat(rootname, ".tsv");

info=textread(jsonfile,'%s');

if(info{1}=='{' & info{2}(1)=='{')
    info={info{2:end-1}};
end
info=strcat(info{:});
info=strrep(info,'""','""');
info=strrep(info,'},{',',');

info=jsondecode(info);

if(exist(tsvfile))
    tbl=readtable(tsvfile,'FileType','text');
else
    tbl=[];
end