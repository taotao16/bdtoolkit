%bdSolve  Solve an initial-value problem using the Brain Dynamics Toolbox
%Usage: 
%   [sol,solx] = bdSolve(sys,tspan,@solverfun,solvertype)
%where
%   sys is a system struct describing the dynamical system
%   tspan=[0 100] is the time span of the integration (optional)
%   @solverfun is a function handle to an ode/dde/sde solver (optional)
%   solvertype is a string describing the type of solver (optional).
%
%   The tspan, @solverfun and solvertype arguments are all optional.
%   If tspan is omitted then it defaults to sys.tspan.
%   If @solverfun is omitted then it defaults to the first solver in sys.
%   If @solverfun is supplied but it is not known to the sys struct then
%   you must also supply the solvertype string ('odesolver', 'ddesolver'
%   or 'sdesolver').
%
%RETURNS
%   sol is the solution structure in the same format as that returned
%      by the matlab ode45 solver.
%   solx is a solution structure that contains any auxiliary variables
%      that the model has defined. The format is the same as sol.
%   Use the bdEval function to extract the results from sol and solx.
%
%EXAMPLE
%    sys = ODEdemo1;                    % construct our system
%    tspan = [0 10];                    % integration time domain
%    sol = bdSolve(sys,tspan);          % solve
%    tplot = 0:0.1:10;                  % time domain of interest
%    Y = bdEval(sol,tplot);             % extract solution
%    plot(tplot,Y);                     % plot the result
%    xlabel('time'); ylabel('y');
%
%AUTHORS
%   Stewart Heitmann (2016a, 2017a)

% Copyright (C) 2016, QIMR Berghofer Medical Research Institute
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
function [sol,solx] = bdSolve(sys,tspan,solverfun,solvertype)
        % check the number of output variables
        if nargout>2
            error('Too many output variables');
        end
        
        % check the number of input variables
        if nargin<1
            error('Not enough input parameters');
        end
   
        % check the validity of the sys struct and fill missing fields with default values
        try
            sys = bdUtils.syscheck(sys);
        catch ME
            throwAsCaller(MException('bdSolve',ME.message));
        end

        % use defaults for missing input parameters
        switch nargin
            case 1      % Case of bdSolve(sys)
                % Get tspan from the sys settings. 
                tspan = sys.tspan;
                % Use the first solver found in the sys settings. 
                solvermap = bdUtils.solverMap(sys);
                solverfun = solvermap(1).solverfunc;
                solvertype = solvermap(1).solvertype;
            case 2      % Case of bdSolve(sys,tspan)
                % Use the first solver found in the sys settings. 
                solvermap = bdUtils.solverMap(sys);
                solverfun = solvermap(1).solverfunc;
                solvertype = solvermap(1).solvertype;
            case 3      % Case of bdSolve(sys,tspan,solverfun)
                % Determine the solvertype from the sys settings
                solvertype = bdUtils.solverType(sys,solverfun);
        end
        
        % Call the appropriate solver
        try
            [sol,solx] = bdUtils.solve(sys,tspan,solverfun,solvertype);
        catch ME
            throwAsCaller(MException('bdSolve',ME.message));
        end
end
