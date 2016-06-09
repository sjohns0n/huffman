classdef branchclass 
    properties(Constant)
        xbs = 8;
    end
    
    properties
        x1;
        x2;
        y1;
        y2;
    end
    
    methods
        % Contructor
        function obj = branchclass(x1, y1, x2, y2)
            if nargin >0
                obj.x1 = x1;
                obj.x2 = x2;
                obj.y1 = y1;
                obj.y2 = y2;
            end
        end
        
        % Draw the branch in fig
        function draw(obj, fig)
           if nargin > 0
               figure(fig);
               % horizontal
               finalx = max(obj.x1, obj.x2) + obj.xbs;
               line([obj.x1 + 3, finalx], [obj.y1, obj.y1]);
               line([obj.x2 + 3, finalx], [obj.y2, obj.y2]);
               % vertical
               line([finalx, finalx], [obj.y1, obj.y2]);
               
               % binary indicator
               % zero on top, one on bottom
               x0 = finalx - 1;
               y0 = max(obj.y1, obj.y2) + 2;
               text(x0, y0, '0', 'FontWeight', 'bold');
               
               x1 = finalx - 1;
               y1 = min(obj.y1, obj.y2) - 2;
               text(x1, y1, '1', 'FontWeight', 'bold');
           end
        end   
    end
end