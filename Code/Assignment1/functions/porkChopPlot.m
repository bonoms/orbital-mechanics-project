function  porkChopPlot(dvPork, depDateMin, depDateMax, arrDateMin, arrDateMax)

figure('Name', 'Pork Chop Plot');
ax = axes;
hold(ax, 'on');

[n1, n2] = size(dvPork);

departureDates = linspace(depDateMin, depDateMax, n1);
arrivalDates = linspace(arrDateMin, arrDateMax, n2);

surf(departureDates, arrivalDates, dvPork.')
contour3(ax, departureDates, arrivalDates, dvPork.', 20, 'k');

view(ax, 3);
epoch = datetime(2000,1,1,12,0,0);

xticks(linspace(departureDates(1), departureDates(end), 6))
yticks(linspace(arrivalDates(1), arrivalDates(end), 6))
xticklabels(string(epoch + days(xticks), 'dd MMM yyyy HH:mm'))
yticklabels(string(epoch + days(yticks), 'dd MMM yyyy'))

xlabel('Departure date')
ylabel('Arrival date')
zlabel('Total \Delta v (km/s)')
colorbar
colormap('autumn') 
grid on


end