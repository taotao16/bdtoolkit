% MultipNoise Ito SDE with multiplicative noise processes
%   Ito stochastic differential system with multiplicative noise.
%     dy = -(a + y*b^2)*(1-y^2)*dt + b(1-y^2)*dW
%
% Authors
%   Stewart Heitmann (2016a,2017a)
%   Matthew Aburn (2016a)
 
% Copyright (C) 2016,2017 QIMR Berghofer Medical Research Institute
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in
%    the documentation and/or other materials provided with the
%    distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
% COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
function sys = MultipNoise()
    % Handles to our SDE functions
    sys.sdeF = @sdeF;               % deterministic coefficients
    sys.sdeG = @sdeG;               % stochastic coefficients
    
    % Our SDE parameters
    sys.pardef = [ struct('name','a', 'value',1.0);
                   struct('name','b', 'value',0.8) ];

    % Our SDE variables           
    sys.vardef = struct('name','y', 'value',0.1);
    
    % Default time span
    sys.tspan = [0 5];
    
    % Specify SDE solvers and default options
    sys.sdesolver = {@sdeEM};           % Pertinent SDE solvers
    sys.sdeoption.InitialStep = 0.005;  % SDE solver step size (optional)
    sys.sdeoption.NoiseSources = 1;     % Number of Wiener noise processes

    % Include the Latex (Equations) panel in the GUI
    sys.panels.bdLatexPanel.title = 'Equations'; 
    sys.panels.bdLatexPanel.latex = {'\textbf{Multiplicative Noise}';
        '';
        'An Ito stochastic differential equation';
        '\qquad $dy = -(a + y\,b^2)(1-y^2)\,dt + b(1-y^2)\,dW_t$';
        'where';
        '\qquad $y(t)$ is the dynamic variable,';
        '\qquad $a$ and $b$ are scalar constants.'};
    
    % Include the Time Portrait panel in the GUI
    sys.panels.bdTimePortrait = [];

    % Include the Solver panel in the GUI
    sys.panels.bdSolverPanel = [];     
    
    % Handle to this function. The GUI uses it to construct a new system. 
    sys.self = str2func(mfilename);
end

% The deterministic coefficient function
function f = sdeF(~,y,a,b)  
    f = -(a + y.*b^2).*(1 - y^2);
end

% The noise coefficient function.
function G = sdeG(~,y,~,b)  
    G = b.*(1 - y^2);
end
