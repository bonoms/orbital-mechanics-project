function setupOrbitalMechanics(assignment)
%SETUPORBITALMECHANICS Add course dependencies and one assignment to the path.
% Authors: Lab team (add contributor names before submission).
% Usage: setupOrbitalMechanics("Assignment1");
% Input: assignment [scalar string], "Assignment1" or "Assignment2".
% Output: none. Adds explicit folders to the current MATLAB search path.

arguments
    assignment (1,1) string {mustBeMember(assignment, ["Assignment1","Assignment2"])}
end

codeDir = fileparts(mfilename('fullpath'));
courseDir = getenv('OM_WEBEEP_DIR');
if isempty(courseDir)
    courseDir = fullfile(fileparts(codeDir), 'course');
end

timeDir = fullfile(courseDir, 'time');
if ~isfile(fullfile(courseDir, 'astroConstants.m')) || ...
        ~isfile(fullfile(timeDir, 'date2mjd2000.m'))
    error('OM:MissingCourseFiles', ...
        'Put the WeBeep bundle in "%s" and extract timeConversion.zip there. See Code/README.md.', ...
        courseDir);
end

sharedDir = fullfile(codeDir, 'Assignment1', 'functions', 'shared');
addpath(courseDir, timeDir, sharedDir, fullfile(codeDir, assignment, 'functions'));
end
