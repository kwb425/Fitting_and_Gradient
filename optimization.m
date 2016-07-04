%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear Fitting and Gradient
%
%%% Variables:
% S, upper-most handle carrying all the other handles
%
%                                                  Written by Kim, Wiback,
%                                                     2016.05.08. Ver.1.1.
%                                                     2016.05.10. Ver.1.2.
%                                                     2016.05.14. Ver.1.3.
%                                                     2016.05.15. Ver.1.4.
%                                                     2016.05.18. Ver.1.5.
%                                                     2016.05.19. Ver.1.6.
%                                                     2016.05.21. Ver.1.7.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function optimization





%% Main figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spacing of objects surrounded by upper-most figure:
% horizontal 50, vertical 50
% spacing of inner objects surrounded by the objects:
% horizontal 10, vertical 20



%%%%%%%%%%%%%%%%%%%
% Upper most figure
%%%%%%%%%%%%%%%%%%%
screen_size = get(0, 'screensize');
fg_size = [1200, 700];
S.fg = figure('units', 'pixels', ...
    'position', ...
    [(screen_size(3) - fg_size(1)) / 2, ... % 1/2*(Screen's x - figure's x)
    (screen_size(4) - fg_size(2)) / 2, ... % 1/2*(Screen's y - figure's y)
    fg_size(1), ... % The figure's x
    fg_size(2)], ... % The figure's y
    'menubar', 'none', ...
    'name','Fitting, Joint, and Gradient', ...
    'numbertitle', 'off', ...
    'resize', 'off');



%%%%%%%%%%%%%%%%%%
% Fitting or joint
%%%%%%%%%%%%%%%%%%
S.bg = uibuttongroup('units', 'pix', ...
    'position', [50, 50, 200, 600], ...
    'title', 'Parameters', 'fontsize', 12, ...
    'titleposition', 'centertop');
S.slide_fj = uicontrol('style', 'popupmenu', ...
    'unit', 'pix', ...
    'position', [60, 600, 180, 30], ...
    'fontsize', 12, ...
    'string', {'Fitting', 'Joint'});
% Initial length for ezaing control (including S.initial_length itself)
S.initial_length = length(fieldnames(S)) + 1;
% no input && ouput == @(~,~) function
% (obj, event, arg, arg ...) == {@function, arg, arg}
set(S.slide_fj, 'callback', {@slide_fj_bool, S})





%% Objects for the Fitting Problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function slide_fj_bool(~, ~, varargin)
        S = varargin{1};
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%
        % Button group objects
        %%%%%%%%%%%%%%%%%%%%%%
        if strcmp(S.slide_fj.String{S.slide_fj.Value}, 'Fitting')
            
            %%% Eraze all the objects of the joint problem.
            if length(fieldnames(S)) ~= S.initial_length % Skip 1st click.
                try
                    if ishandle(S.pt_max_iter_j)
                        delete(S.pt_length_1);
                        delete(S.et_length_1);
                        delete(S.ck_length_1);
                        delete(S.pt_length_2);
                        delete(S.et_length_2);
                        delete(S.ck_length_2);
                        delete(S.pt_angle_1);
                        delete(S.et_angle_1);
                        delete(S.ck_angle_1);
                        delete(S.pt_angle_2);
                        delete(S.et_angle_2);
                        delete(S.ck_angle_2);
                        delete(S.pt_lambda_length);
                        delete(S.et_lambda_length);
                        delete(S.ck_lambda_length);
                        delete(S.pt_lambda_angle);
                        delete(S.et_lambda_angle);
                        delete(S.ck_lambda_angle);
                        delete(S.pt_max_iter_j);
                        delete(S.et_max_iter_j);
                        delete(S.ck_max_iter_j);
                        delete(S.pt_tolerance_j);
                        delete(S.et_tolerance_j);
                        delete(S.ck_tolerance_j);
                        delete(S.pb_joint_start);
                        delete(S.ck_title);
                        delete(S.ax_data);
                        delete(S.ax_error);
                        delete(S.ax_gradient_1);
                        delete(S.ax_gradient_2);
                        delete(S.et_process_j);
                        % Do not allow switching to the same category.
                    elseif ishandle(S.pt_max_iter_f)
                        return
                    end
                    % Escape when the deleting is not possible.
                catch
                    return
                end
            end
            
            %%% Samples
            S.pt_sample = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 550, 70, 30], ...
                'string', 'Samples', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ... % Color is no use with this option.
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_sample = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 550, 70, 30], ...
                'string', 'Around 30', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_sample = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 550, 20, 30]);
            
            %%% Lambda: factor 1
            S.pt_lambda_1 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 500, 70, 30], ...
                'string', 'Factor 1 lambda', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_lambda_1 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 500, 70, 30], ...
                'string', '< 0.0001', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_lambda_1 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 500, 20, 30]);
            
            %%% Lambda: factor 2
            S.pt_lambda_2 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 450, 70, 30], ...
                'string', 'Factor 2 lambda', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_lambda_2 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 450, 70, 30], ...
                'string', '< 0.0001', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_lambda_2 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 450, 20, 30]);
            
            %%% Max iteration
            S.pt_max_iter_f = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 400, 70, 30], ...
                'string', 'Max iteration', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_max_iter_f = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 400, 70, 30], ...
                'string', 'Around 300', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_max_iter_f = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 400, 20, 30]);
            
            %%% Tolerance
            S.pt_tolerance_f = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 350, 70, 30], ...
                'string', 'Tolerance', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_tolerance_f = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 350, 70, 30], ...
                'string', 'Around 0.1', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_tolerance_f = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 350, 20, 30]);
            
            %%% Ground truth function
            S.pt_ground = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 300, 70, 30], ...
                'string', 'Y function', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Slide for the user's input
            S.slide_ground = uicontrol('style', 'popupmenu', ...
                'unit', 'pix', ...
                'position', [135, 297, 82, 30], ...
                'fontsize', 12, ...
                'string', {'y = ax + b', 'y = a * sin(b*x + c)'});
            % Checkbox for automation option
            S.ck_ground = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 300, 20, 30]);
            
            %%% Start button
            S.pb_fitting_start = uicontrol('style', 'pushbutton', ...
                'unit', 'pix', ...
                'position', [60, 70, 180, 50], ...
                'string', 'Start!', ...
                'fontsize', 15, ...
                'horizontalalign', 'center', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            
            %%% The checkboxes' title
            S.ck_title = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [215, 575, 30, 15], ...
                'string', 'Auto', ...
                'fontsize', 7, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'fontweight', 'bold');
            
            
            
            %%%%%%
            % Axes
            %%%%%%
            
            %%% Data plot
            S.ax_data = axes('units', 'pixels', ...
                'position', [300, 375, 400, 275], ...
                'NextPlot', 'replacechildren');
            title(S.ax_data, 'Data and fitting', 'fontsize', 15)
            
            %%% Error plot
            S.ax_error = axes('units', 'pixels', ...
                'position', [750, 375, 400, 275]);
            title(S.ax_error, 'Errors', 'fontsize', 15)
            
            %%% Gradient plots
            S.ax_gradient_1 = axes('units', 'pixels', ...
                'position', [300, 50, 400, 275], ...
                'NextPlot', 'replacechildren');
            title(S.ax_gradient_1, ...
                'Error function of factor 1', 'fontsize', 15)
            S.ax_gradient_2 = axes('units', 'pixels', ...
                'position', [750, 50, 400, 275]);
            title(S.ax_gradient_2, ...
                'Error function of factor 2', 'fontsize', 15)
            % Gradient subplots
            S.ax_gradient_1_1 = axes('units', 'pixels', ...
                'position', [300, 246, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_1_1, ...
                'Error function of factor 1 w.r.t. w\_1 & w\_2', ...
                'fontsize', 15)
            S.ax_gradient_1_2 = axes('units', 'pixels', ...
                'position', [300, 148, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_1_2, ...
                'Error function of factor 1 w.r.t. w\_2 & w\_3', ...
                'fontsize', 15)
            S.ax_gradient_1_3 = axes('units', 'pixels', ...
                'position', [300, 50, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_1_3, ...
                'Error function of factor 1 w.r.t. w\_1 & w\_3', ...
                'fontsize', 15)
            S.ax_gradient_2_1 = axes('units', 'pixels', ...
                'position', [750, 246, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_2_1, ...
                'Error function of factor 2 w.r.t. w\_1 & w\_2', ...
                'fontsize', 15)
            S.ax_gradient_2_2 = axes('units', 'pixels', ...
                'position', [750, 148, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_2_2, ...
                'Error function of factor 2 w.r.t. w\_2 & w\_3', ...
                'fontsize', 15)
            S.ax_gradient_2_3 = axes('units', 'pixels', ...
                'position', [750, 50, 400, 79], ...
                'NextPlot', 'replacechildren', ...
                'visible', 'off', ...
                'xtick', {}, ...
                'xticklabel', {}, ...
                'ytick', {}, ...
                'yticklabel', {});
            title(S.ax_gradient_2_3, ...
                'Error function of factor 2 w.r.t. w\_1 & w\_3', ...
                'fontsize', 15)
            
            
            
            %%%%%%%%%%%%%
            % Process bar
            %%%%%%%%%%%%%
            S.et_process_f = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [590, 660, 300, 30], ...
                'string', 'Process bar', ...
                'fontsize', 20, ...
                'ForegroundColor', 'red', ...
                'backgroundcolor', [1, 1, 1], ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            
            
            
            
            
            %% Updating S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(S.slide_fj, 'callback', {@slide_fj_bool, S})
            set(S.ck_sample, 'callback', {@ck_sample_bool, S})
            set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
            set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
            set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
            set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
            set(S.ck_ground, 'callback', {@ck_ground_bool, S})
            set(S.pb_fitting_start, 'callback', ...
                {@pb_fitting_start_call, S})
            
            
            
            
            
        %% Objects for the Joint Problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        %%%%%%%%%%%%%%%%%%%%%%
        % Button group objects
        %%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(S.slide_fj.String{S.slide_fj.Value}, 'Joint')
            
            %%% Eraze all the objects of the fitting problem.
            if length(fieldnames(S)) ~= S.initial_length % Skip 1st click.
                try
                    if ishandle(S.pt_max_iter_f)
                        delete(S.pt_sample);
                        delete(S.et_sample);
                        delete(S.ck_sample);
                        delete(S.pt_lambda_1);
                        delete(S.et_lambda_1);
                        delete(S.ck_lambda_1);
                        delete(S.pt_lambda_2);
                        delete(S.et_lambda_2);
                        delete(S.ck_lambda_2);
                        delete(S.pt_ground);
                        delete(S.slide_ground);
                        delete(S.pt_max_iter_f);
                        delete(S.et_max_iter_f);
                        delete(S.ck_max_iter_f);
                        delete(S.pt_tolerance_f);
                        delete(S.et_tolerance_f);
                        delete(S.ck_tolerance_f);
                        delete(S.ck_ground);
                        delete(S.pb_fitting_start);
                        delete(S.ck_title);
                        delete(S.ax_data);
                        delete(S.ax_error);
                        delete(S.ax_gradient_1);
                        delete(S.ax_gradient_2);
                        delete(S.et_process_f);
                        delete(S.ax_gradient_1_1)
                        delete(S.ax_gradient_1_2)
                        delete(S.ax_gradient_1_3)
                        delete(S.ax_gradient_2_1)
                        delete(S.ax_gradient_2_2)
                        delete(S.ax_gradient_2_3)
                        % Do not allow switching to the same category.
                    elseif ishandle(S.pt_max_iter_j)
                        return
                    end
                    % Escape when the deleting is not possible.
                catch
                    return
                end
            end
            
            %%% Length 1
            S.pt_length_1 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 550, 70, 30], ...
                'string', 'Length 1', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ... % Color is no use with this option.
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_length_1 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 550, 70, 30], ...
                'string', 'Around 30', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_length_1 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 550, 20, 30]);
            
            %%% Length 2
            S.pt_length_2 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 500, 70, 30], ...
                'string', 'Length 2', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_length_2 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 500, 70, 30], ...
                'string', 'Around 30', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_length_2 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 500, 20, 30]);
            
            %%% Angle 1
            S.pt_angle_1 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 450, 70, 30], ...
                'string', 'Angle 1', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_angle_1 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 450, 70, 30], ...
                'string', 'Around 45', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_angle_1 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 450, 20, 30]);
            
            %%% Angle 2
            S.pt_angle_2 = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 400, 70, 30], ...
                'string', 'Angle 2', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_angle_2 = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 400, 70, 30], ...
                'string', 'Around 45', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_angle_2 = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 400, 20, 30]);
            
            %%% Lambda: length
            S.pt_lambda_length = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 350, 70, 30], ...
                'string', 'Length lambda', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_lambda_length = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 350, 70, 30], ...
                'string', '< 0.01', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_lambda_length = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 350, 20, 30]);
            
            %%% Lambda: angle
            S.pt_lambda_angle = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 300, 70, 30], ...
                'string', 'Angle lambda', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_lambda_angle = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 300, 70, 30], ...
                'string', '< 0.0001', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_lambda_angle = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 300, 20, 30]);
            
            %%% Max iteration
            S.pt_max_iter_j = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 250, 70, 30], ...
                'string', 'Max iteration', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_max_iter_j = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 250, 70, 30], ...
                'string', 'Around 300', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_max_iter_j = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 250, 20, 30]);
            
            %%% Tolerance
            S.pt_tolerance_j = uicontrol('style', 'edit', ...
                'unit', 'pix', ...
                'position', [60, 200, 70, 30], ...
                'string', 'Tolerance', ...
                'fontsize', 8, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            % Editable text for the user's input
            S.et_tolerance_j = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [140, 200, 70, 30], ...
                'string', 'Around 0.1', ...
                'fontsize', 12, ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            % Checkbox for automation option
            S.ck_tolerance_j = uicontrol('style', 'checkbox', ...
                'unit', 'pix', ...
                'position', [220, 200, 20, 30]);
            
            %%% Start button
            S.pb_joint_start = uicontrol('style', 'pushbutton', ...
                'unit', 'pix', ...
                'position', [60, 70, 180, 50], ...
                'string', 'Start!', ...
                'fontsize', 15, ...
                'horizontalalign', 'center', ...
                'backgroundcolor', [0.7, 0.7, 0.7]);
            
            %%% The checkboxes' title
            S.ck_title = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [215, 575, 30, 15], ...
                'string', 'Auto', ...
                'fontsize', 7, ...
                'horizontalalign', 'center', ...
                'enable', 'off', ...
                'fontweight', 'bold');
            
            
            
            %%%%%%
            % Axes
            %%%%%%
            
            %%% Data plot
            S.ax_data = axes('units', 'pixels', ...
                'position', [300, 375, 400, 275], ...
                'NextPlot', 'replacechildren');
            title(S.ax_data, 'Where to?', 'fontsize', 15)
            
            %%% Error plot
            S.ax_error = axes('units', 'pixels', ...
                'position', [750, 375, 400, 275]);
            title(S.ax_error, 'Errors', 'fontsize', 15)
            
            %%% Gradient plots
            S.ax_gradient_1 = axes('units', 'pixels', ...
                'position', [300, 50, 400, 275], ...
                'NextPlot', 'replacechildren');
            title(S.ax_gradient_1, ...
                'Error function of length', 'fontsize', 15)
            S.ax_gradient_2 = axes('units', 'pixels', ...
                'position', [750, 50, 400, 275]);
            title(S.ax_gradient_2, ...
                'Error function of angle', 'fontsize', 15)
            
            
            
            %%%%%%%%%%%%%
            % Process bar
            %%%%%%%%%%%%%
            S.et_process_j = uicontrol('style', 'edit', ...
                'units', 'pix', ...
                'position', [590, 660, 300, 30], ...
                'string', 'Process bar', ...
                'fontsize', 20, ...
                'ForegroundColor', 'red', ...
                'backgroundcolor', [1, 1, 1], ...
                'horizontalalign', 'center', ...
                'fontweight', 'bold');
            
            
            
            
            
            %% Updating S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(S.slide_fj, 'callback', {@slide_fj_bool, S})
            set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
            set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
            set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
            set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
            set(S.ck_lambda_length, 'callback', ...
                {@ck_lambda_length_bool, S})
            set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
            set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
            set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
            set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
        end
    end





%% Checkboxes Callbacks for the Fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_sample_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_sample, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_sample, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_sample, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_lambda_1_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_lambda_1, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_lambda_1, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_lambda_1, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_lambda_2_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_lambda_2, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_lambda_2, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_lambda_2, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 4
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_max_iter_f_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_max_iter_f, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_max_iter_f, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_max_iter_f, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_tolerance_f_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_tolerance_f, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_tolerance_f, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_tolerance_f, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 6
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_ground_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.slide_ground, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.slide_ground, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.slide_ground, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_sample, 'callback', {@ck_sample_bool, S})
        set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
        set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
        set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
        set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
        set(S.ck_ground, 'callback', {@ck_ground_bool, S})
        set(S.pb_fitting_start, 'callback', {@pb_fitting_start_call, S})
    end





%% Checkboxes Callbacks for the Joint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_length_1_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_length_1, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_length_1, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_length_1, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_length_2_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_length_2, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_length_2, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_length_2, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 3
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_angle_1_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_angle_1, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_angle_1, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_angle_1, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 4
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_angle_2_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_angle_2, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_angle_2, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_angle_2, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_lambda_length_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_lambda_length, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_lambda_length, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_lambda_length, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 6
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_lambda_angle_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_lambda_angle, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_lambda_angle, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_lambda_angle, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 7
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_max_iter_j_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_max_iter_j, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_max_iter_j, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_max_iter_j, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Checkbox switch control: 8
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function ck_tolerance_j_bool(~, ~, varargin)
        S = varargin{1};
        
        %%% Switch control
        switch get(S.et_tolerance_j, 'enable')
            % When off, enable the edit box.
            case 'off'
                set(S.et_tolerance_j, 'enable', 'on')
                % When on, disable the edit box.
            case 'on'
                set(S.et_tolerance_j, 'enable', 'off')
        end
        
        %%% Updating S
        set(S.slide_fj, 'callback', {@slide_fj_bool, S})
        set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
        set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
        set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
        set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
        set(S.ck_lambda_length, 'callback', {@ck_lambda_length_bool, S})
        set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
        set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
        set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
        set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
    end





    %% Activation Function of the Fitting Problem %%%%%%%%%%%%%%%%%%%%%%%%
    function pb_fitting_start_call(~, ~, varargin)
        % Proceed only with the start button (not the stop button).
        if strcmp(get(S.pb_fitting_start, 'string'), 'Start!')
            set(S.pb_fitting_start, 'string', 'Stop!')
            set(S.et_process_f, 'string', 'Processing...')
            pause(0.1)
            
            
            
            %%%%%%%%%%%%
            % Parameters
            %%%%%%%%%%%%
            S = varargin{1};
            
            %%% Samples
            % Auto
            if get(S.ck_sample, 'value')
                S.sample = 30;
            % Self
            else
                S.sample = str2double(get(S.et_sample, 'string'));
            end
            
            %%% Factor 1's lambda
            % Auto
            if get(S.ck_lambda_1, 'value')
                S.lambda_1 = 0.0001;
            % Self
            else
                S.lambda_1 = str2double(get(S.et_lambda_1, 'string'));
            end
            
            %%% Factor 2's lambda
            % Auto
            if get(S.ck_lambda_2, 'value')
                S.lambda_2 = 0.0001;
            % Self
            else
                S.lambda_2 = str2double(get(S.et_lambda_2, 'string'));
            end
            
            %%% Max iterations
            % Auto
            if get(S.ck_max_iter_f, 'value')
                S.max_iter_f = 300;
            % Self
            else
                S.max_iter_f = str2double(get(S.et_max_iter_f, 'string'));
            end
            
            %%% Tolerance
            % Auto
            if get(S.ck_tolerance_f, 'value')
                S.tolerance_f = 0.1;
            % Self
            else
                S.tolerance_f = ...
                    str2double(get(S.et_tolerance_f, 'string'));
            end
            
            %%% Ground truth function
            % Auto
            if get(S.ck_ground, 'value')
                S.ground = 'y = ax + b';
            % Self
            else
                S.ground = S.slide_ground.String{...
                    get(S.slide_ground, 'value')};
            end
            
            
            
            
            
            %% Linear model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(S.ground, 'y = ax + b')
                
                
                
                %%%%%%%%%%%%%%%%%
                % Generating data
                %%%%%%%%%%%%%%%%%
                % The two factors' x coordinates
                x_1 = -S.sample:1:S.sample;
                x_2 = -S.sample:1:S.sample;
                % Y matrix whose n'th column is n'th factor.
                Y = zeros(length(x_1), 2);
                % Random data from the ground truth
                Y(:, 1) = (2*x_1)' + ...
                    median(x_1)*randn(length(x_1), 1) + 1*max(x_1);
                Y(:, 2) = (5*x_2)' + ...
                    median(x_2)*randn(length(x_2), 1) + 3*max(x_2);
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%
                % Symbolic mathematics
                %%%%%%%%%%%%%%%%%%%%%%
                % Can not use 'syms' here (due to workspace scope).
                ground_t = sym('ground_t', [length(Y), 1]);
                w_1 = sym('w_1');
                w_2 = sym('w_2');
                x = sym('x', [length(x_1), 1]);
                
                %%% Model
                linear_model = w_1*x.^1 + w_2*x.^0;
                
                %%% Sum Square Error
                sse = sum((linear_model - ground_t).^2);
                
                %%% Partial derivatives
                gl_w_1 = diff(sse, w_1);
                gl_w_2 = diff(sse, w_2);
                % Variance of the partial derivatives
                v_gl_w_1 = norm(gl_w_1);
                v_gl_w_2 = norm(gl_w_2);
                
                %%% Transitioning to anonymous functions
                linear_model = matlabFunction(linear_model, ...
                    'vars', {w_1, w_2, x});
                sse = matlabFunction(sse, 'vars', {ground_t, w_1, w_2, x});
                gl_w_1 = matlabFunction(gl_w_1, ...
                    'vars', {ground_t, w_1, w_2, x});
                gl_w_2 = matlabFunction(gl_w_2, ...
                    'vars', {ground_t, w_1, w_2, x});
                v_gl_w_1 = matlabFunction(v_gl_w_1, 'vars', ...
                    {ground_t, w_1, w_2, x});
                v_gl_w_2 = matlabFunction(v_gl_w_2, 'vars', ...
                    {ground_t, w_1, w_2, x});
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Gradient, initialization
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%% Random initialization for factor 1
                curr_fac_1_w_1 = 14; %#ok<NASGU> suppresing MATLAB warning
                prev_fac_1_w_1 = 14;
                curr_fac_1_w_2 = 4*max(x_1); %#ok<NASGU>
                prev_fac_1_w_2 = 4*max(x_1);
                
                %%% Random initialization for factor 2
                curr_fac_2_w_1 = 1; %#ok<NASGU>
                prev_fac_2_w_1 = 1;
                curr_fac_2_w_2 = 2*max(x_2); %#ok<NASGU>
                prev_fac_2_w_2 = 2*max(x_2);
                
                
                
                %%%%%%%%%%%%%%%%
                % Gradient, loop
                %%%%%%%%%%%%%%%%
                iteration = 0;
                while iteration < S.max_iter_f
                    iteration = iteration + 1;
                    
                    %%% Factor 1's update
                    curr_fac_1_w_1 = ...
                        prev_fac_1_w_1 - 0.02 * S.lambda_1 * ... % Less
                        gl_w_1(Y(:, 1), ...
                        prev_fac_1_w_1, prev_fac_1_w_2, x_1');
                    curr_fac_1_w_2 = ...
                        prev_fac_1_w_2 - 2 * S.lambda_1 * ... % More
                        gl_w_2(Y(:, 1), ...
                        prev_fac_1_w_1, prev_fac_1_w_2, x_1');
                    
                    %%% Factor 2's update
                    curr_fac_2_w_1 = ...
                        prev_fac_2_w_1 - 0.02 * S.lambda_2 * ... % Less
                        gl_w_1(Y(:, 2), ...
                        prev_fac_2_w_1, prev_fac_2_w_2, x_2');
                    curr_fac_2_w_2 = ...
                        prev_fac_2_w_2 - 2 * S.lambda_2 * ... % More
                        gl_w_2(Y(:, 2), ...
                        prev_fac_2_w_1, prev_fac_2_w_2, x_2');
                    
                    %%% Plotting
                    if iteration == 1
                        % Axes switching
                        set(S.ax_gradient_1, 'visible', 'on')
                        set(S.ax_gradient_1_1, 'visible', 'off')
                        set(S.ax_gradient_1_2, 'visible', 'off')
                        set(S.ax_gradient_1_3, 'visible', 'off')
                        set(S.ax_gradient_2, 'visible', 'on')
                        set(S.ax_gradient_2_1, 'visible', 'off')
                        set(S.ax_gradient_2_2, 'visible', 'off')
                        set(S.ax_gradient_2_3, 'visible', 'off')
                        % Clearing
                        cla(S.ax_data)
                        cla(S.ax_error)
                        cla(S.ax_gradient_1)
                        cla(S.ax_gradient_2)
                        cla(S.ax_gradient_1_1)
                        cla(S.ax_gradient_1_2)
                        cla(S.ax_gradient_1_3)
                        cla(S.ax_gradient_2_1)
                        cla(S.ax_gradient_2_2)
                        cla(S.ax_gradient_2_3)
                        % Holding
                        hold(S.ax_data, 'on')
                        ylim(S.ax_data, [min(Y(:)), max(Y(:))]) % Limiting
                        hold(S.ax_error, 'on')
                        hold(S.ax_gradient_1, 'on')
                        hold(S.ax_gradient_2, 'on')
                        
                        %%% Plotting: initial data
                        plot(S.ax_data, x_1, Y(:, 1), 'ro', ...
                            x_2, Y(:, 2), 'go')
                        
                        %%% Plotting: initial error
                        plot(S.ax_error, iteration, ...
                            sse(Y(:, 1), prev_fac_1_w_1, ...
                            prev_fac_1_w_2, x_1'), 'ro', ...
                            iteration, sse(Y(:, 2), prev_fac_2_w_1, ...
                            prev_fac_2_w_2, x_2'), 'go')
                        
                        %%% Plotting: initial gradient of factor 1
                        [fac_1_error_w_1, fac_1_error_w_2] = meshgrid(...
                            (-4*prev_fac_1_w_1:1:4*prev_fac_1_w_1), ...
                            (-4*prev_fac_1_w_2:1:4*prev_fac_1_w_2));
                        contour(S.ax_gradient_1, ...
                            fac_1_error_w_1, fac_1_error_w_2, ...
                            sse(Y(:, 1), fac_1_error_w_1, ...
                            fac_1_error_w_2, x_1'), 20)
                        
                        %%% Plotting: initial gradient of factor 2
                        [fac_2_error_w_1, fac_2_error_w_2] = meshgrid(...
                            (-8*prev_fac_2_w_1:1:8*prev_fac_2_w_1), ...
                            (-8*prev_fac_2_w_2:1:8*prev_fac_2_w_2));
                        contour(S.ax_gradient_2, ...
                            fac_2_error_w_1, fac_2_error_w_2, ...
                            sse(Y(:, 2), fac_2_error_w_1, ...
                            fac_2_error_w_2, x_2'), 20)
                        
                        
                        
                    %%%%%%%%%%%%%%%%
                    % Gradient, step
                    %%%%%%%%%%%%%%%%
                    else
                        
                        %%% Step by step: data
                        % Clear -> Draw -> Clear -> Draw -> ...
                        if iteration > 2 && all(ishandle(before))
                            delete(before)
                        end
                        before = plot(S.ax_data, ...
                            x_1, linear_model(curr_fac_1_w_1, ...
                            curr_fac_1_w_2, x_1'), 'r', ...
                            x_2, linear_model(curr_fac_2_w_1, ...
                            curr_fac_2_w_2, x_2'), 'g');
                        
                        %%% Step by step: error
                        plot(S.ax_error, ...
                            iteration, sse(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, x_1'), ...
                            'ro', ...
                            iteration, sse(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, x_2'), ...
                            'go')
                        
                        %%% Step by step: gradient of factor 1
                        plot3(S.ax_gradient_1, ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            sse(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, x_1'), 'ro')
                        
                        %%% Step by step: gradient of factor 2
                        plot3(S.ax_gradient_2, ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            sse(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, x_2'), 'go')
                    end
                    drawnow
                    
                    
                    
                    %%%%%%%%%%%%%%%%%%%%
                    % Gradient, renewing
                    %%%%%%%%%%%%%%%%%%%%
                    prev_fac_1_w_1 = curr_fac_1_w_1;
                    prev_fac_1_w_2 = curr_fac_1_w_2;
                    prev_fac_2_w_1 = curr_fac_2_w_1;
                    prev_fac_2_w_2 = curr_fac_2_w_2;
                    
                    
                    
                    %%%%%%%%%%%%%%%%%%%
                    % Gradient, options
                    %%%%%%%%%%%%%%%%%%%
                    
                    %%% Verbose
                    set(S.et_process_f, 'string', ...
                        sprintf('Iteration: %d', iteration));
                    
                    %%% Escaping
                    % Max iteration escape
                    if iteration == S.max_iter_f
                        set(S.et_process_f, 'string', ...
                            'All iterations exhausted');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    % Nice fit escape
                    elseif sse(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, x_1') && ...
                            sse(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, x_2') < 10
                        % The error is 2nd poly convex, thus global min.
                        set(S.et_process_f, 'string', 'Global optimal!');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    % No more change escape
                    elseif v_gl_w_1(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, x_1') && ...
                            v_gl_w_2(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, x_1') && ...
                            v_gl_w_1(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, x_2') && ...
                            v_gl_w_2(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, x_2') ...
                            < S.tolerance_f % +300
                        % The error is 2nd poly convex, thus global min.
                        set(S.et_process_f, 'string', 'Global minimum');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    end
                    % The user's requested escape
                    if ~get(S.pb_fitting_start, 'value')
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    end
                end
                
                
                
                
                
            %% Periodic model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif strcmp(S.ground, 'y = a * sin(b*x + c)')
                
                
                
                %%%%%%%%%%%%%%%%%
                % Generating data
                %%%%%%%%%%%%%%%%%
                % The two factors' x coordinates
                x_1 = -3*S.sample:2*pi:3*S.sample;
                x_2 = -3*S.sample:2*pi:3*S.sample;
                x_1 = x_1 * pi/180;
                x_2 = x_2 * pi/180;
                % Amplitude, frequency, and phase constants
                constant_w_1_f_1 = 2;
                constant_w_2_f_1 = 5;
                constant_w_3_f_1 = 1/3*pi;
                constant_w_1_f_2 = 3;
                constant_w_2_f_2 = 8;
                constant_w_3_f_2 = 1/4*pi;
                % Y matrix whose n'th column is n'th factor.
                Y = zeros(length(x_1), 2);
                % Random data from the ground truth
                Y(:, 1) = constant_w_1_f_1 * ...
                    sin(constant_w_2_f_1*x_1 + constant_w_3_f_1);
                Y(:, 2) = constant_w_1_f_2 * ...
                    sin(constant_w_2_f_2*x_2 + constant_w_3_f_2);
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%
                % Symbolic mathematics
                %%%%%%%%%%%%%%%%%%%%%%
                % Can not use 'syms' here (due to workspace scope).
                ground_t = sym('ground_t', [length(Y), 1]);
                w_1 = sym('w_1');
                w_2 = sym('w_2');
                w_3 = sym('w_3');
                x = sym('x', [length(x_1), 1]);
                
                %%% Model
                periodic_model = w_1 * sin(w_2*x + w_3);
                
                %%% Sum Square Error
                sse = sum((periodic_model - ground_t).^2);
                
                %%% Partial derivatives
                gl_w_1 = diff(sse, w_1);
                gl_w_2 = diff(sse, w_2);
                gl_w_3 = diff(sse, w_3);
                % Variance of the partial derivatives
                v_gl_w_1 = norm(gl_w_1);
                v_gl_w_2 = norm(gl_w_2);
                v_gl_w_3 = norm(gl_w_3);
                
                %%% Transitioning to anonymous functions
                periodic_model = matlabFunction(periodic_model, ...
                    'vars', {w_1, w_2, w_3, x});
                sse = matlabFunction(sse, 'vars', ...
                    {ground_t, w_1, w_2, w_3, x});
                gl_w_1 = matlabFunction(gl_w_1, ...
                    'vars', {ground_t, w_1, w_2, w_3, x});
                gl_w_2 = matlabFunction(gl_w_2, ...
                    'vars', {ground_t, w_1, w_2, w_3, x});
                gl_w_3 = matlabFunction(gl_w_3, ...
                    'vars', {ground_t, w_1, w_2, w_3, x});
                v_gl_w_1 = matlabFunction(v_gl_w_1, 'vars', ...
                    {ground_t, w_1, w_2, w_3, x});
                v_gl_w_2 = matlabFunction(v_gl_w_2, 'vars', ...
                    {ground_t, w_1, w_2, w_3, x});
                v_gl_w_3 = matlabFunction(v_gl_w_3, 'vars', ...
                    {ground_t, w_1, w_2, w_3, x});
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                % Gradient, initialization
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%% Random initialization for factor 1
                curr_fac_1_w_1 = constant_w_1_f_1 + randi(3); %#ok<NASGU>
                prev_fac_1_w_1 = constant_w_1_f_1 + randi(3);
                curr_fac_1_w_2 = constant_w_2_f_1 + randi(3); %#ok<NASGU>
                prev_fac_1_w_2 = constant_w_2_f_1 + randi(3);
                curr_fac_1_w_3 = constant_w_3_f_1 + pi/4; %#ok<NASGU>
                prev_fac_1_w_3 = constant_w_3_f_1 + pi/4;
                
                %%% Random initialization for factor 2
                curr_fac_2_w_1 = constant_w_1_f_2 + randi(3); %#ok<NASGU>
                prev_fac_2_w_1 = constant_w_1_f_2 + randi(3);
                curr_fac_2_w_2 = constant_w_2_f_2 + randi(3); %#ok<NASGU>
                prev_fac_2_w_2 = constant_w_2_f_2 + randi(3);
                curr_fac_2_w_3 = constant_w_3_f_2 + pi/4; %#ok<NASGU>
                prev_fac_2_w_3 = constant_w_3_f_2 + pi/4;
                
                
                
                %%%%%%%%%%%%%%%%
                % Gradient, loop
                %%%%%%%%%%%%%%%%
                iteration = 0;
                while iteration < S.max_iter_f
                    iteration = iteration + 1;
                    
                    %%% Factor 1's update
                    curr_fac_1_w_1 = ...
                        prev_fac_1_w_1 - 5 * S.lambda_1 * ... % More
                        gl_w_1(Y(:, 1), ...
                        prev_fac_1_w_1, prev_fac_1_w_2, ...
                        prev_fac_1_w_3, x_1');
                    curr_fac_1_w_2 = ...
                        prev_fac_1_w_2 - 5 * S.lambda_1 * ... % More
                        gl_w_2(Y(:, 1), ...
                        prev_fac_1_w_1, prev_fac_1_w_2, ...
                        prev_fac_1_w_3, x_1');
                    curr_fac_1_w_3 = ...
                        prev_fac_1_w_3 - 5 * S.lambda_1 * ... % More
                        gl_w_3(Y(:, 1), ...
                        prev_fac_1_w_1, prev_fac_1_w_2, ...
                        prev_fac_1_w_3, x_1');
                    
                    %%% Factor 2's update
                    curr_fac_2_w_1 = ...
                        prev_fac_2_w_1 - 5 * S.lambda_2 * ... % More
                        gl_w_1(Y(:, 2), ...
                        prev_fac_2_w_1, prev_fac_2_w_2, ...
                        prev_fac_2_w_3, x_2');
                    curr_fac_2_w_2 = ...
                        prev_fac_2_w_2 - 5 * S.lambda_2 * ... % More
                        gl_w_2(Y(:, 2), ...
                        prev_fac_2_w_1, prev_fac_2_w_2, ...
                        prev_fac_2_w_3, x_2');
                    curr_fac_2_w_3 = ...
                        prev_fac_2_w_3 - 5 * S.lambda_2 * ... % More
                        gl_w_3(Y(:, 2), ...
                        prev_fac_2_w_1, prev_fac_2_w_2, ...
                        prev_fac_2_w_3, x_2');
                    
                    %%% Plotting
                    if iteration == 1
                        % Axes switching
                        set(S.ax_gradient_1, 'visible', 'off')
                        set(S.ax_gradient_1_1, 'visible', 'on')
                        set(S.ax_gradient_1_2, 'visible', 'on')
                        set(S.ax_gradient_1_3, 'visible', 'on')
                        set(S.ax_gradient_2, 'visible', 'off')
                        set(S.ax_gradient_2_1, 'visible', 'on')
                        set(S.ax_gradient_2_2, 'visible', 'on')
                        set(S.ax_gradient_2_3, 'visible', 'on')
                        % Clearing
                        cla(S.ax_data)
                        cla(S.ax_error)
                        cla(S.ax_gradient_1)
                        cla(S.ax_gradient_2)
                        cla(S.ax_gradient_1_1)
                        cla(S.ax_gradient_1_2)
                        cla(S.ax_gradient_1_3)
                        cla(S.ax_gradient_2_1)
                        cla(S.ax_gradient_2_2)
                        cla(S.ax_gradient_2_3)
                        % Holding
                        hold(S.ax_data, 'on')
                        ylim(S.ax_data, [min(Y(:)), max(Y(:))]) % Limiting
                        hold(S.ax_error, 'on')
                        hold(S.ax_gradient_1_1, 'on')
                        hold(S.ax_gradient_1_2, 'on')
                        hold(S.ax_gradient_1_3, 'on')
                        hold(S.ax_gradient_2_1, 'on')
                        hold(S.ax_gradient_2_2, 'on')
                        hold(S.ax_gradient_2_3, 'on')
                        
                        %%% Plotting: initial data
                        plot(S.ax_data, ...
                            x_1, Y(:, 1), 'ro', x_2, Y(:, 2), 'go')
                        
                        %%% Plotting: initial error
                        plot(S.ax_error, ...
                            iteration, sse(Y(:, 1), ...
                            prev_fac_1_w_1, prev_fac_1_w_2, ...
                            prev_fac_1_w_3, x_1'), 'ro', ...
                            iteration, sse(Y(:, 2), ...
                            prev_fac_2_w_1, prev_fac_2_w_2, ...
                            prev_fac_2_w_3, x_2'), 'go')
                        
                        %%% Plotting: initial gradient of factor 1
                        [fac_1_error_w_1, fac_1_error_w_2] = meshgrid(...
                            (-1.5*prev_fac_1_w_1:1:1.5*prev_fac_1_w_1), ...
                            (-2*prev_fac_1_w_2:1:2*prev_fac_1_w_2));
                        contour(S.ax_gradient_1_1, ...
                            fac_1_error_w_1, fac_1_error_w_2, ...
                            sse(Y(:, 1), fac_1_error_w_1, ...
                            fac_1_error_w_2, prev_fac_1_w_3, x_1'), 20)
                        [fac_1_error_w_2, fac_1_error_w_3] = meshgrid(...
                            (-1.5*prev_fac_1_w_2:1:1.5*prev_fac_1_w_2), ...
                            (-2*prev_fac_1_w_3:1:2*prev_fac_1_w_3));
                        contour(S.ax_gradient_1_2, ...
                            fac_1_error_w_2, fac_1_error_w_3, ...
                            sse(Y(:, 1), fac_1_error_w_2, ...
                            fac_1_error_w_3, prev_fac_1_w_1, x_1'), 20)
                        [fac_1_error_w_1, fac_1_error_w_3] = meshgrid(...
                            (-1.5*prev_fac_1_w_1:1:1.5*prev_fac_1_w_1), ...
                            (-2*prev_fac_1_w_3:1:2*prev_fac_1_w_3));
                        contour(S.ax_gradient_1_3, ...
                            fac_1_error_w_1, fac_1_error_w_3, ...
                            sse(Y(:, 1), fac_1_error_w_1, ...
                            fac_1_error_w_3, prev_fac_1_w_2, x_1'), 20)
                        
                        %%% Plotting: initial gradient of factor 2
                        [fac_2_error_w_1, fac_2_error_w_2] = meshgrid(...
                            (-1.5*prev_fac_2_w_1:1:1.5*prev_fac_2_w_1), ...
                            (-2*prev_fac_2_w_2:1:2*prev_fac_2_w_2));
                        contour(S.ax_gradient_2_1, ...
                            fac_2_error_w_1, fac_2_error_w_2, ...
                            sse(Y(:, 2), fac_2_error_w_1, ...
                            fac_2_error_w_2, prev_fac_2_w_3, x_2'), 20)
                        [fac_2_error_w_2, fac_2_error_w_3] = meshgrid(...
                            (-1.5*prev_fac_2_w_2:1:1.5*prev_fac_2_w_2), ...
                            (-2*prev_fac_2_w_3:1:2*prev_fac_2_w_3));
                        contour(S.ax_gradient_2_2, ...
                            fac_2_error_w_2, fac_2_error_w_3, ...
                            sse(Y(:, 2), fac_2_error_w_2, ...
                            fac_2_error_w_3, prev_fac_2_w_1, x_2'), 20)
                        [fac_2_error_w_1, fac_2_error_w_3] = meshgrid(...
                            (-1.5*prev_fac_2_w_1:1:1.5*prev_fac_2_w_1), ...
                            (-2*prev_fac_2_w_3:1:2*prev_fac_2_w_3));
                        contour(S.ax_gradient_2_3, ...
                            fac_2_error_w_1, fac_2_error_w_3, ...
                            sse(Y(:, 2), fac_2_error_w_1, ...
                            fac_2_error_w_3, prev_fac_2_w_2, x_2'), 20)
                    else
                        
                        
                        
                        %%%%%%%%%%%%%%%%
                        % Gradient, step
                        %%%%%%%%%%%%%%%%
                        
                        %%% Step by step: data
                        % Clear -> Draw -> Clear -> Draw -> ...
                        if iteration > 2 && all(ishandle(before))
                            delete(before)
                        end
                        before = plot(S.ax_data, ...
                            x_1, periodic_model(curr_fac_1_w_1, ...
                            curr_fac_1_w_2, curr_fac_1_w_3, x_1'), 'r', ...
                            x_2, periodic_model(curr_fac_2_w_1, ...
                            curr_fac_2_w_2, curr_fac_2_w_3, x_2'), 'g');
                        
                        %%% Step by step: error
                        plot(S.ax_error, ...
                            iteration, sse(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            curr_fac_1_w_3, x_1'), 'ro', ...
                            iteration, sse(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            curr_fac_2_w_3, x_2'), 'go')
                        
                        %%% Step by step: gradient of factor 1
                        plot3(S.ax_gradient_1_1, ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            sse(Y(:, 1), curr_fac_1_w_1, ...
                            curr_fac_1_w_2, curr_fac_1_w_3, x_1'), 'ro')
                        plot3(S.ax_gradient_1_2, ...
                            curr_fac_1_w_2, curr_fac_1_w_3, ...
                            sse(Y(:, 1), curr_fac_1_w_1, ...
                            curr_fac_1_w_2, curr_fac_1_w_3, x_1'), 'ro')
                        plot3(S.ax_gradient_1_3, ...
                            curr_fac_1_w_1, curr_fac_1_w_3, ...
                            sse(Y(:, 1), curr_fac_1_w_1, ...
                            curr_fac_1_w_2, curr_fac_1_w_3, x_1'), 'ro')
                        
                        %%% Step by step: gradient of factor 2
                        plot3(S.ax_gradient_2_1, ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            sse(Y(:, 2), curr_fac_2_w_1, ...
                            curr_fac_2_w_2, curr_fac_2_w_3, x_2'), 'go')
                        plot3(S.ax_gradient_2_2, ...
                            curr_fac_2_w_2, curr_fac_2_w_3, ...
                            sse(Y(:, 2), curr_fac_2_w_1, ...
                            curr_fac_2_w_2, curr_fac_2_w_3, x_2'), 'go')
                        plot3(S.ax_gradient_2_3, ...
                            curr_fac_2_w_1, curr_fac_2_w_3, ...
                            sse(Y(:, 2), curr_fac_2_w_1, ...
                            curr_fac_2_w_2, curr_fac_2_w_3, x_2'), 'go')
                    end
                    drawnow
                    
                    
                    
                    %%%%%%%%%%%%%%%%%%%%
                    % Gradient, renewing
                    %%%%%%%%%%%%%%%%%%%%
                    prev_fac_1_w_1 = curr_fac_1_w_1;
                    prev_fac_1_w_2 = curr_fac_1_w_2;
                    prev_fac_1_w_3 = curr_fac_1_w_3;
                    prev_fac_2_w_1 = curr_fac_2_w_1;
                    prev_fac_2_w_2 = curr_fac_2_w_2;
                    prev_fac_2_w_3 = curr_fac_2_w_3;
                    
                    
                    
                    %%%%%%%%%%%%%%%%%%%
                    % Gradient, options
                    %%%%%%%%%%%%%%%%%%%
                    
                    %%% Verbose
                    set(S.et_process_f, 'string', ...
                        sprintf('Iteration: %d', iteration));
                    
                    %%% Escaping
                    % Max iteration escape
                    if iteration == S.max_iter_f
                        set(S.et_process_f, ...
                            'string', 'All iterations exhausted');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    % Nice fit escape
                    elseif sse(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            curr_fac_1_w_3, x_1') && ...
                            sse(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            curr_fac_2_w_3, x_2') ...
                            < 0.1
                        set(S.et_process_f, 'string', 'Possible optimal!');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    % No more change escape
                    elseif v_gl_w_1(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            curr_fac_1_w_3, x_1') && ...
                            v_gl_w_2(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            curr_fac_1_w_3, x_1') && ...
                            v_gl_w_3(Y(:, 1), ...
                            curr_fac_1_w_1, curr_fac_1_w_2, ...
                            curr_fac_1_w_3, x_1') && ...
                            v_gl_w_1(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            curr_fac_2_w_3, x_2') && ...
                            v_gl_w_2(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            curr_fac_2_w_3, x_2') && ...
                            v_gl_w_3(Y(:, 2), ...
                            curr_fac_2_w_1, curr_fac_2_w_2, ...
                            curr_fac_2_w_3, x_2') ...
                            < 1/10000 * S.tolerance_f
                        set(S.et_process_f, 'string', 'Local minima');
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    end
                    % The user's requested escape
                    if ~get(S.pb_fitting_start, 'value')
                        set(S.pb_fitting_start, 'string', 'Start!')
                        return
                    end
                end
            end
            
            
            
            
            
            %% Updating S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(S.slide_fj, 'callback', {@slide_fj_bool, S})
            set(S.ck_sample, 'callback', {@ck_sample_bool, S})
            set(S.ck_lambda_1, 'callback', {@ck_lambda_1_bool, S})
            set(S.ck_lambda_2, 'callback', {@ck_lambda_2_bool, S})
            set(S.ck_max_iter_f, 'callback', {@ck_max_iter_f_bool, S})
            set(S.ck_tolerance_f, 'callback', {@ck_tolerance_f_bool, S})
            set(S.ck_ground, 'callback', {@ck_ground_bool, S})
            set(S.pb_fitting_start, 'callback', ...
                {@pb_fitting_start_call, S})
        end
    end





    %% Linear Model with 4 Coefficients %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pb_joint_start_call(~, ~, varargin)
        % Proceed only with the start button (not the stop button).
        if strcmp(get(S.pb_joint_start, 'string'), 'Start!')
            set(S.pb_joint_start, 'string', 'Stop!')
            set(S.et_process_j, 'string', 'Processing...')
            
            
            
            %%%%%%%%%%%%
            % Parameters
            %%%%%%%%%%%%
            S = varargin{1};
            
            %%% Length 1
            % Auto
            if get(S.ck_length_1, 'value')
                S.length_1 = 30;
            % Self
            else
                S.length_1 = str2double(get(S.et_length_1, 'string'));
            end
            
            %%% Length 2
            % Auto
            if get(S.ck_length_2, 'value')
                S.length_2 = 30;
            % Self
            else
                S.length_2 = str2double(get(S.et_length_2, 'string'));
            end
            
            %%% Angle 1
            % Auto
            if get(S.ck_angle_1, 'value')
                S.angle_1 = 45 * pi/180;
            % Self
            else
                S.angle_1 = ...
                    str2double(get(S.et_angle_1, 'string')) * pi/180;
            end
            
            %%% Angle 2
            % Auto
            if get(S.ck_angle_2, 'value')
                S.angle_2 = 45 * pi/180;
            % Self
            else
                S.angle_2 = ...
                    str2double(get(S.et_angle_2, 'string')) * pi/180;
            end
            
            %%% lambda for the length
            % Auto
            if get(S.ck_lambda_length, 'value')
                S.lambda_length = 0.01;
            % Self
            else
                S.lambda_length = ...
                    str2double(get(S.et_lambda_length, 'string'));
            end
            
            %%% lambda for the angle
            % Auto
            if get(S.ck_lambda_angle, 'value')
                S.lambda_angle = 0.0001;
            % Self
            else
                S.lambda_angle = ...
                    str2double(get(S.et_lambda_angle, 'string'));
            end
            
            %%% Max iterations
            % Auto
            if get(S.ck_max_iter_j, 'value')
                S.max_iter_j = 300;
            % Self
            else
                S.max_iter_j = str2double(get(S.et_max_iter_j, 'string'));
            end
            
            %%% Tolerance
            % Auto
            if get(S.ck_tolerance_j, 'value')
                S.tolerance_j = 0.1;
            % Self
            else
                S.tolerance_j = ...
                    str2double(get(S.et_tolerance_j, 'string'));
            end
            
            
            
            %%%%%%%%%%%%%
            % Initial arm
            %%%%%%%%%%%%%
            cla(S.ax_data)
            before_arm = plot(S.ax_data, [0, S.length_1*cos(S.angle_1), ...
                S.length_1*cos(S.angle_1)+S.length_2*cos(S.angle_2)], ...
                [0, S.length_1*sin(S.angle_1), ...
                S.length_1*sin(S.angle_1)-S.length_2*sin(S.angle_2)], ...
                'r-o');
            xlim(S.ax_data, [-3*S.length_1, 3*S.length_1])
            ylim(S.ax_data, [-3*S.length_1, 3*S.length_1])
            
            %%% The user's destination
            [user_x, user_y] = ginput(1);
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%
            % Symbolic mathematics
            %%%%%%%%%%%%%%%%%%%%%%
            % Can not use 'syms' here (due to workspace scope).
            
            %%% Model
            l_1 = sym('l_1');
            l_2 = sym('l_2');
            a_1 = sym('a_1');
            a_2 = sym('a_2');
            
            %%% Sum Square Error
            sse = (l_1*cos(a_1) + l_2*cos(a_2) - user_x)^2 + ...
                (l_1*sin(a_1) - l_2*sin(a_2) - user_y)^2;
            
            %%% Partial derivatives
            g_l_1 = diff(sse, l_1);
            g_l_2 = diff(sse, l_2);
            g_a_1 = diff(sse, a_1);
            g_a_2 = diff(sse, a_2);
            % Variance of the partial derivatives
            v_g_l_1 = norm(g_l_1);
            v_g_l_2 = norm(g_l_2);
            v_g_a_1 = norm(g_a_1);
            v_g_a_2 = norm(g_a_2);
            
            %%% Transitioning to anonymous functions
            sse = matlabFunction(sse);
            g_l_1 = matlabFunction(g_l_1);
            g_l_2 = matlabFunction(g_l_2);
            g_a_1 = matlabFunction(g_a_1);
            g_a_2 = matlabFunction(g_a_2);
            v_g_l_1 = matlabFunction(v_g_l_1);
            v_g_l_2 = matlabFunction(v_g_l_2);
            v_g_a_1 = matlabFunction(v_g_a_1);
            v_g_a_2 = matlabFunction(v_g_a_2);
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%
            % Gradient, initialization
            %%%%%%%%%%%%%%%%%%%%%%%%%%
            curr_l_1 = S.length_1; %#ok<NASGU>
            prev_l_1 = S.length_1;
            curr_l_2 = S.length_2; %#ok<NASGU>
            prev_l_2 = S.length_2;
            curr_a_1 = S.angle_1; %#ok<NASGU>
            prev_a_1 = S.angle_1;
            curr_a_2 = S.angle_2; %#ok<NASGU>
            prev_a_2 = S.angle_2;
            
            
            
            %%%%%%%%%%%%%%%%
            % Gradient, loop
            %%%%%%%%%%%%%%%%
            iteration = 0;
            while iteration < S.max_iter_j
                iteration = iteration + 1;
                
                %%% Length 1's update
                curr_l_1 = prev_l_1 - ...
                    0.5 * S.lambda_length ... % Less shift
                    * g_l_1(prev_a_1, prev_a_2, prev_l_1, prev_l_2);
                
                %%% Length 2's update
                curr_l_2 = prev_l_2 - ...
                    0.5 * S.lambda_length ... % Less shift
                    * g_l_2(prev_a_1, prev_a_2, prev_l_1, prev_l_2);
                
                %%% Angle 1's update
                curr_a_1 = prev_a_1 - ...
                    0.2 * S.lambda_angle ... % Less shift
                    * g_a_1(prev_a_1, prev_a_2, prev_l_1, prev_l_2);
                
                %%% Angle 2's update
                curr_a_2 = prev_a_2 - ...
                    0.2 * S.lambda_angle ... % Less shift
                    * g_a_2(prev_a_1, prev_a_2, prev_l_1, prev_l_2);
                
                %%% Plotting
                if iteration == 1
                    % Clearing
                    cla(S.ax_data)
                    cla(S.ax_error)
                    cla(S.ax_gradient_1)
                    cla(S.ax_gradient_2)
                    % Holding
                    hold(S.ax_data, 'on')
                    hold(S.ax_error, 'on')
                    hold(S.ax_gradient_1, 'on')
                    hold(S.ax_gradient_2, 'on')
                    
                    %%% Plotting: initial arm was plotted earlier.
                    
                    %%% Plotting: initial error
                    plot(S.ax_error, iteration, sse(prev_a_1, prev_a_2, ...
                        prev_l_1, prev_l_2), 'bo')
                    
                    %%% Plotting: initial gradient of the length
                    [error_l_1, error_l_2] = meshgrid(...
                        (-4*curr_l_1:1:4*curr_l_1), ...
                        (-4*curr_l_2:1:4*curr_l_2));
                    contour(S.ax_gradient_1, error_l_1, error_l_2, ...
                        sse(prev_a_1, prev_a_2, error_l_1, error_l_2), 20)
                    
                    %%% Plotting: initial gradient of the angle
                    [error_a_1, error_a_2] = meshgrid(...
                        (-4*curr_a_1:0.1:4*curr_a_1), ...
                        (-4*curr_a_2:0.1:4*curr_a_2));
                    contour(S.ax_gradient_2, error_a_1, error_a_2, ...
                        sse(error_a_1, error_a_2, prev_l_1, prev_l_2), 20)
                    
                    
                    
                    %%%%%%%%%%%%%%%%
                    % Gradient, step
                    %%%%%%%%%%%%%%%%
                else
                    
                    %%% Step by step: arm movement
                    % Clear -> Draw -> Clear -> Draw -> ...
                    if iteration > 1 && ishandle(before_arm)
                        delete(before_arm)
                        delete(before_user)
                    end
                    before_arm = plot(S.ax_data, ...
                        [0, curr_l_1*cos(curr_a_1), ...
                        curr_l_1*cos(curr_a_1)+curr_l_2*cos(curr_a_2)], ...
                        [0, curr_l_1*sin(curr_a_1), ...
                        curr_l_1*sin(curr_a_1)-curr_l_2*sin(curr_a_2)], ...
                        'r-o');
                    before_user = plot(S.ax_data, user_x, user_y, 'bo');
                    
                    %%% Step by step: error
                    plot(S.ax_error, iteration, sse(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2), 'bo')
                    
                    %%% Step by step: gradient of the length
                    plot3(S.ax_gradient_1, curr_l_1, curr_l_2, ...
                        sse(curr_a_1, curr_a_2, curr_l_1, curr_l_2), 'ro')
                    
                    %%% Step by step: gradient of the angle
                    plot3(S.ax_gradient_2, curr_a_1, curr_a_2, ...
                        sse(curr_a_1, curr_a_2, curr_l_1, curr_l_2), 'go')
                end
                drawnow
                
                
                
                %%%%%%%%%%%%%%%%%%%%
                % Gradient, renewing
                %%%%%%%%%%%%%%%%%%%%
                prev_l_1 = curr_l_1;
                prev_l_2 = curr_l_2;
                prev_a_1 = curr_a_1;
                prev_a_2 = curr_a_2;
                
                
                
                %%%%%%%%%%%%%%%%%%%
                % Gradient, options
                %%%%%%%%%%%%%%%%%%%
                
                %%% Verbose
                set(S.et_process_j, 'string', ...
                    sprintf('Iteration: %d', iteration));
                
                %%% Escaping
                % Max iteration escape
                if iteration == S.max_iter_j
                    set(S.et_process_j, ...
                        'string', 'All iterations exhausted');
                    set(S.pb_joint_start, 'string', 'Start!')
                    return
                % Nice fit escape
                elseif sse(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2) < 1
                    set(S.et_process_j, 'string', 'Possible optimal!');
                    set(S.pb_joint_start, 'string', 'Start!')
                    return
                % No more change escape
                elseif v_g_l_1(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2) && ...
                        v_g_l_2(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2) && ...
                        v_g_a_1(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2) && ...
                        v_g_a_2(curr_a_1, curr_a_2, ...
                        curr_l_1, curr_l_2) ...
                        < S.tolerance_j
                    set(S.et_process_j, 'string', 'Local minima');
                    set(S.pb_joint_start, 'string', 'Start!')
                    return
                end
                % The user's requested escape
                if ~get(S.pb_joint_start, 'value')
                    set(S.pb_joint_start, 'string', 'Start!')
                    return
                end
            end
            
            
            
            
            
            %% Updating S %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(S.slide_fj, 'callback', {@slide_fj_bool, S})
            set(S.ck_length_1, 'callback', {@ck_length_1_bool, S})
            set(S.ck_length_2, 'callback', {@ck_length_2_bool, S})
            set(S.ck_angle_1, 'callback', {@ck_angle_1_bool, S})
            set(S.ck_angle_2, 'callback', {@ck_angle_2_bool, S})
            set(S.ck_lambda_length, 'callback', ...
                {@ck_lambda_length_bool, S})
            set(S.ck_lambda_angle, 'callback', {@ck_lambda_angle_bool, S})
            set(S.ck_max_iter_j, 'callback', {@ck_max_iter_j_bool, S})
            set(S.ck_tolerance_j, 'callback', {@ck_tolerance_j_bool, S})
            set(S.pb_joint_start, 'callback', {@pb_joint_start_call, S})
        end
    end
end