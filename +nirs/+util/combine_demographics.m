function demo = combine_demographics(demoOrig)

demo=Dictionary;
flds = demoOrig.Properties.VariableNames;
for i=1:length(flds)
    try
        if(length(unique(demoOrig.(flds{i})))==1)
            demo(demoOrig.Properties.VariableNames{i})=demoOrig.(flds{i})(1);
        end
    end
end

try
    included_subjects_n = length(unique(demoOrig.SubjectID));
    demo.included_subjects_n = included_subjects_n;
end