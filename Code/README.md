# Run the Orbital Mechanics assignments

1. Open `om.prj` from the repository root in MATLAB.
2. Keep your downloaded WeBeep MATLAB functions outside the repository. Extract `timeConversion.zip` there and pass the folder containing `astroConstants.m` to the setup function:

   ```matlab
   webeepDir = uigetdir(pwd, 'Select the external WeBeep MATLAB functions folder');
   if ~isequal(webeepDir, 0)
       setup(string(webeepDir))
   end
   ```

   If you extracted the `time/` folder elsewhere, use `setup(webeepDir, timeDir)`. Run setup once per MATLAB session before using the course functions. For a submission copy containing only `Code/`, add `Code/` and the chosen assignment's `functions/` folder to the MATLAB path, then run the same setup function.
3. Open and run the relevant entry script:
   - `Assignment1/InterplanetaryMission_group_2602.m`
   - `Assignment2/PlanetaryMission_group_2602.m`

The entry scripts are templates. Put student-written helpers in the corresponding assignment's `functions/` folder. The `Code/` tree holds the student submission code and instructions.
