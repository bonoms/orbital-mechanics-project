function [dvMatrix, missionOptimal, dvOptimal] = missionOptimizer(depDateMin, depDateMax, encDateMin, encDateMax, arrDateMin, arrDateMax, nDep, nEnc, nArr)
%MISSIONOPTIMIZER Searches the transfer-epoch grid for the minimum delta-v mission
%
% PROTOTYPE:
% [dvMatrix, missionOptimal, dvOptimal, porkChop] = missionOptimizer(depDateMin, depDateMax, ...
%     encDateMin, encDateMax, arrDateMin, arrDateMax, nDep, nEnc, nArr)
%
% INPUT:
% depDateMin [1x1] Minimum departure epoch [T]
% depDateMax [1x1] Maximum departure epoch [T]
% encDateMin [1x1] Minimum encounter epoch [T]
% encDateMax [1x1] Maximum encounter epoch [T]
% arrDateMin [1x1] Minimum arrival epoch [T]
% arrDateMax [1x1] Maximum arrival epoch [T]
% nDep [1x1] Number of departure epochs to sample
% nEnc [1x1] Number of encounter epochs to sample
% nArr [1x1] Number of arrival epochs to sample
%
% OUTPUT:
% dvMatrix [nDep x nEnc x nArr] Delta-v values for all feasible missions [L/T]
% missionOptimal [1x1] Mission structure associated with the minimum delta-v solution
% dvOptimal [1x1] Minimum delta-v in the search grid [km/s].
% porkChop [struct] with depTimes, encTimes and arrTimes [MJD2000 days].
%     cost [nArr x nDep] contains the minimum over all encounter dates [km/s].
%     encounterDate [nArr x nDep] contains the winning encounter epoch
%     [MJD2000 days]. Both matrices use NaN for pairs with no valid legs.
%
% AUTHOR:
% Lorenzo Bonomi
%
% DESCRIPTION:
% Samples the departure, encounter, and arrival epoch ranges with a regular
% grid, evaluates each candidate mission using legAssembler, and stores the
% total delta-v for feasible cases. The function then identifies the mission
% with the lowest delta-v and returns both the corresponding mission
% structure and its total delta-v.

depTimes = linspace(depDateMin, depDateMax, nDep);
encTimes = linspace(encDateMin, encDateMax, nEnc);
arrTimes = linspace(arrDateMin, arrDateMax, nArr);

dvMatrix = nan(nDep, nEnc, nArr);

for i = 1:nDep
    for k = 1:nEnc
        for l = 1:nArr
            if depTimes(i) >= encTimes(k) || encTimes(k) >= arrTimes(l)
                continue
            end
            [dv, mission] = legAssembler(depTimes(i), encTimes(k), arrTimes(l));
            if mission.ok && isfinite(dv)
                dvMatrix(i, k, l) = dv;
            end
        end
    end
end

[~, idxOpt] = min(dvMatrix(:));
[idx1, idx2, idx3] = ind2sub(size(dvMatrix), idxOpt);

[dvOptimal, missionOptimal] = legAssembler(depTimes(idx1), encTimes(idx2), arrTimes(idx3));

end
