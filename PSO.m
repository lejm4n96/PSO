function [GBEST] = PSO(noParticles, maxIter, problem, visFlag, counterEndVal)

%Details der Zielfunktion
nVar = problem.nVar; %Anzahl der Variablen
ub = problem.ub;  %obere Grenze
lb = problem.lb;  %untere Grenze
fobj = problem.fobj; 

%Extra Variablen für die Visualisierung
position_history = zeros(noParticles, maxIter, nVar);

%Definition der PSO´s Parameter
wMax = 0.9;%inertia weight
wMin = 0.2;%inertia weight
c1 = 2;%Beschleunigungsfaktor 
c2 = 2;%Beschleunigungsfaktor 

% Damit die Particle die Landschaft nicht verlassen wird die
% Geschwindigkeit der einzelnen Particle begrenzt.
%20 Prozent des Variablenbereichs
vMax = (ub-lb)*0.2;
vMin = -vMax;

GBEST_not_improved_counter = 0;

%PSO-Algorithmus

%Initialisieren der Partikel
for k = 1 : noParticles
    Swarm.Particles(k).X = (ub - lb).*rand(1, nVar) + lb;
    Swarm.Particles(k).V = zeros(1, nVar);
    Swarm.Particles(k).PBEST.X = zeros(1, nVar);
    Swarm.Particles(k).PBEST.O = inf;
    
    Swarm.GBEST.X = zeros(1, nVar);
    Swarm.GBEST.O = inf;
end

tic;
%Main loop
stop = false;
t = 0;
while stop == false
    t = t+1;
    %erhöhe den counter, wenn GBEST nicht verbessert wurde
    GBEST_not_improved_counter = GBEST_not_improved_counter + 1;
    
    %Berechnen des Zielwertes
    for k = 1 : noParticles
        
        currentX = Swarm.Particles(k).X;
        position_history(k, t, :) = currentX;
        
        Swarm.Particles(k).O = fobj(currentX);
        
        %Aktualisierung PBEST
        if Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O
            Swarm.Particles(k).PBEST.X = currentX;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
        end   
        
        %Aktualisierung GBEST
        if Swarm.Particles(k).O < Swarm.GBEST.O
            Swarm.GBEST.X = currentX;
            Swarm.GBEST.O = Swarm.Particles(k).O;
            %setze den Counter auf 0, wenn eine Verbesserung des GBEST
            %gefunden wurde
            GBEST_not_improved_counter = 0;
        end 
    end
    
   %Aktualisieren der X- und V Vektoren
   w = wMax - t.*((wMax - wMin)/maxIter);
   
   for k = 1 : noParticles
    Swarm.Particles(k).V = w.*Swarm.Particles(k).V+c1.*rand(1,nVar).*(Swarm.Particles(k).PBEST.X-Swarm.Particles(k).X)...
                                                  +c2.*rand(1,nVar).*(Swarm.GBEST.X-Swarm.Particles(k).X);  
                                              
    % finden der Particle Geschwindigkeit die größer als max Geschwindigkeit 
    %und kleiner als min Geschwindigkeit
    index1 = find(Swarm.Particles(k).V > vMax);
    index2 = find(Swarm.Particles(k).V < vMin);
    
    %aktualisieren der Geschwindigkeit
    Swarm.Particles(k).V(index1)= vMax(index1);
    Swarm.Particles(k).V(index2)= vMin(index2);
    
    Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V; 
    
    % finden der Particle Position die größer ist als die obere grenze
    %und kleiner als untere Grenze
    index1 = find(Swarm.Particles(k).X > ub);
    index2 = find(Swarm.Particles(k).X < lb);
    
    %aktualisieren der Position
    Swarm.Particles(k).X(index1)= ub(index1);
    Swarm.Particles(k).X(index2)= lb(index2);
    
   end
   
   outmsg = ['Iteration#', num2str(t), 'Swarm.GBEST.O= ',num2str(Swarm.GBEST.O)];
   disp(outmsg);

   %PSO beenden, wennn der Counter den wert counterEndVal erreicht hat.
   if GBEST_not_improved_counter >= counterEndVal
    stop = true;
   end
   
   %fileName = ['saves\Resultat nach Iteration#',num2str(t)];
   %save(fileName);

end
toc;

GBEST = Swarm.GBEST;

if visFlag == 1
%Zeichne die Landschaft      
    figure
    
    x = -50 : 1 : 50;
    y = -50 : 1 : 50;
    
    [x_new , y_new] = meshgrid(x,y);
    
    for k1 = 1: size(x_new, 1)
        for k2 = 1 : size(x_new , 2)
            X = [ x_new(k1,k2) , y_new(k1, k2) ];
            z(k1,k2) = ObjectiveFunction( X );
        end
    end
    
    subplot(1,2,1)
    surfc(x_new , y_new , z);
    title('Suchlandschaft')
    xlabel('x_1')
    ylabel('x_2')
    zlabel('Objective value')
    shading interp
    camproj perspective
    box on
    
%Visualisierung des Suchverlaufs
    subplot(1,2,2)
    hold on
    for p = 1 : noParticles
        for t = 1 : maxIter
            x = position_history(p, t , 1);
            y = position_history(p, t , 2);
            plot(x , y , '.k' );
        end
    end
    contour(x_new , y_new , z);
    plot(Swarm.GBEST.X(1) , Swarm.GBEST.X(2) , 'og');
    xlim([lb(1) , ub(1)])
    ylim([lb(2) , ub(2)])
    title('Suchverlauf')
    xlabel('x')
    ylabel('y')
    box on
end
end