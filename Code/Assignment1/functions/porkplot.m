function [deltaVtotMatrix] = porkplot(t1min, t1max, t2min, t2max, planetDeparture, planetArrival, numberOfPossibilities)
% t is given in mj2000
%  planets refer to uplanet ephemeridis convention
 
deltaVtotMatrix = zeros(numberOfPossibilities,numberOfPossibilities);
mu_sun = astroConstants(4);

departureDates = linspace(t1min, t1max, numberOfPossibilities);
arrivalDates = linspace(t2min, t2max, numberOfPossibilities);

t1 = 0;
t2 = 0;


for i=1:numberOfPossibilities

    for j=1:numberOfPossibilities

        t1 = departureDates(i);
        t2 = arrivalDates(j);


        [kepDep, ~] = uplanet(t1, planetDeparture);
        [kepArr, ~] = uplanet(t2, planetArrival);
        
        carDep = kep2car(kepDep, mu_sun);
        carArr = kep2car(kepArr, mu_sun);

        rDep = carDep(1:3);
        rArr = carArr(1:3);

        [~ , v1, v2] = lambert(rDep, rArr, 24*60*60*(t2-t1), 1, mu_sun);

        deltaVtotMatrix(i,j) = norm(v1-carDep(4:6)) + norm(v2-carArr(4:6));
        
    end
end


surf(departureDates, arrivalDates, deltaVtotMatrix.')
epoch = datetime(2000,1,1,12,0,0);

xticks(linspace(departureDates(1), departureDates(end), 4))
yticks(linspace(arrivalDates(1), arrivalDates(end), 4))
xticklabels(string(epoch + days(xticks), 'dd MMM yyyy HH:mm'))
yticklabels(string(epoch + days(yticks), 'dd MMM yyyy'))

xlabel('Departure date')
ylabel('Arrival date')
zlabel('Total \Delta v (km/s)')
colorbar
