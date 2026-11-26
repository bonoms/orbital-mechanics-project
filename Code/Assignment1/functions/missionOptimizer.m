function [dvMatrix, missionOptimal, dvOptimal] = missionOptimizer(depDateMin, depDateMax, encDateMin, encDateMax, arrDateMin, arrDateMax, nDep, nEnc, nArr)

depTimes = linspace(depDateMin, depDateMax, nDep);
encTimes = linspace(encDateMin, encDateMax, nEnc);
arrTimes = linspace(arrDateMin, arrDateMax, nArr);

dvMatrix = NaN*ones(nDep,nEnc, nArr);

for i = 1:nDep
    for k = 1:nEnc
          for l = 1:nArr
              [dv, mission] = legAssembler(depTimes(i), encTimes(k), arrTimes(l));
              if (mission.ok) 
                  dvMatrix(i, k, l) = dv;
              end
          end
    end
end

[~ , index] = min(dvMatrix(:));
[idx1, idx2, idx3] = ind2sub(size(dvMatrix), index);

[dvOptimal, missionOptimal] = legAssembler(depTimes(idx1), encTimes(idx2), arrTimes(idx3));

end