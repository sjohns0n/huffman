classdef probclass
    properties
        nodeID;
        x; % x location of text 
        y; % y location of text 
        p; % probability value
        blvl = 1; % branch level
    end
    
    methods
        % Constructor
       function obj = probclass(ID, x, y, p, blvl)
            if nargin > 0
                obj.nodeID = ID;
                obj.x = x;
                obj.y = y;
                obj.p = p;
                obj.blvl = blvl;
            end
       end
        
       % Draw the node to fig
       function draw(obj, fig)
          if nargin > 0
             figure(fig);
             text(obj.x, obj.y, num2str(obj.p, '%.3f'));
          end
       end
       
    end
end