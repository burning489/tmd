function plot_fval(f_vals, opt_values)
% PLOT_FVAL Plot energy function values while the algorithm executes.
% Parameters
% ==============================
% f_vals: double
%         Total energy function value at xn.
% opt_values: struct
%             opt_values.n_iter: integer
%                                Current number of iterations.
%             opt_values.e_bulk: double
%                                Bulk energy at xn.
%             opt_values.e_inter: double
%                                 Interface energy at xn.
%             opt_values.e_elas: double
%                                Elastic energy at xn.
% See also optimplotfval
global root_path;
if opt_values.n_iter == 0
    set(0, 'CurrentFigure', 1);
    plotfval = plot(0, f_vals, 0, opt_values.e_bulk, 0, opt_values.e_inter, 0, opt_values.e_elas);
    legend({'total','bulk','interface','elas'}, "Location", "northwest");
    set(plotfval(1), 'Tag', 'fval');
    set(plotfval(2), 'Tag', 'e_bulk');
    set(plotfval(3), 'Tag', 'e_inter');
    set(plotfval(4), 'Tag', 'e_elas');
    title(sprintf("function values during %d iterations", opt_values.n_iter));
    drawnow
else
    set(0, 'CurrentFigure', 1);
    plotfval = findobj(get(gcf,'Children'), 'Tag', 'fval');
    f_vals = [plotfval.YData, f_vals];
    set(plotfval, 'YData', f_vals);
    set(plotfval, 'XData', 0:opt_values.n_iter);
    
    plotbulk = findobj(get(gcf,'Children'), 'Tag', 'e_bulk');
    bulk_vals = [plotbulk.YData, opt_values.e_bulk];
    set(plotbulk, 'YData', bulk_vals);
    set(plotbulk, 'XData', 0:opt_values.n_iter);
    
    plotinter = findobj(get(gcf,'Children'), 'Tag', 'e_inter');
    inter_vals = [plotinter.YData, opt_values.e_inter];
    set(plotinter, 'YData', inter_vals);
    set(plotinter, 'XData', 0:opt_values.n_iter);
    
    plotelas = findobj(get(gcf,'Children'), 'Tag', 'e_elas');
    elas_vals = [plotelas.YData, opt_values.e_elas];
    set(plotelas, 'YData', elas_vals);
    set(plotelas, 'XData', 0:opt_values.n_iter);
    
    title(sprintf("function values during %d iterations", opt_values.n_iter));
    drawnow
end
if mod(opt_values.n_iter, 1000) == 0
    i = get_run_index();
    saveas(1, sprintf(root_path+"/results/run%03d/energy.png", i));
end
end