function create_gif(i)
global root_path;
h = figure("Visible", "off");
axis tight manual % this ensures that getframe() returns a consistent size
filename = sprintf(root_path+"/results/run%03d/movie.gif", i);
pics = dir(sprintf(root_path+"/results/run%03d/phase_*.png", i));
for n = 1:length(pics)
    img = imread(pics(n).name);
    image(img);
    set(gca,'XColor', 'none','YColor','none')
    drawnow
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if n == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
end

