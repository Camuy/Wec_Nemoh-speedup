%% Save Workspace
% it save in the inferential model folder
%save('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/workspace.mat')


%% Plot
% Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave response for body 2
output.plotResponse(2,3);

%Plot heave forces for body 1
output.plotForces(1,3);

%Plot heave forces for body 2
output.plotForces(2,3);

%Plot power extracted
figure(223);
%plot(output.ptos.time, -abs(output.ptos.powerInternalMechanics));
plot(output.ptos.time, -pto.damping.*output.ptos.velocity(:, 3).^2, '-b', output.ptos.time, trapz(-pto.damping.*output.ptos.velocity(:, 3).^2)./length(output.ptos.time)*ones(length(output.ptos.time)), '-r'), grid on, hold on;
xlabel('time');
ylabel('extracted power');
legend('P', 'P_{med}');
title('Power Extracted PTO')

% d = c.e3;
