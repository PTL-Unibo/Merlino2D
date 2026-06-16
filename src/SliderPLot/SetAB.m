function [A,B] = SetAB(A0,B0)
A = A0;
B = B0;

L = 300;
H = 100;
fig = uifigure("Name","CutLine","Position",[300,300,L,H], "Resize","off");

y1 = 0.35;
y2 = 0.7;
dy = 0.3;

uilabel(fig, 'Text', 'A = [', 'Position',round([0.03,y2,0.15,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"right");
uilabel(fig, 'Text', 'B = [', 'Position',round([0.03,y1,0.15,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"right");
Ax = uieditfield(fig, "Position",round([0.2,y2,0.35,dy].*[L,H,L,H]),"Value",sprintf("%.5e",A0(1)));
Bx = uieditfield(fig, "Position",round([0.2,y1,0.35,dy].*[L,H,L,H]),"Value",sprintf("%.5e",B0(1)));
uilabel(fig, 'Text', ',', 'Position',round([0.55,y2,0.05,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"center");
uilabel(fig, 'Text', ',', 'Position',round([0.55,y1,0.05,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"center");
Ay = uieditfield(fig, "Position",round([0.6,y2,0.3,dy].*[L,H,L,H]),"Value",sprintf("%.5e",A0(2)));
By = uieditfield(fig, "Position",round([0.6,y1,0.3,dy].*[L,H,L,H]),"Value",sprintf("%.5e",B0(2)));
uilabel(fig, 'Text', ']', 'Position',round([0.92,y2,0.1,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"left");
uilabel(fig, 'Text', ']', 'Position',round([0.92,y1,0.1,dy].*[L,H,L,H]), 'FontSize',20, 'HorizontalAlignment',"left");
uibutton(fig, 'Text','Apply', 'Position',round([0.3,0.05,0.5,0.25].*[L,H,L,H]), 'ButtonPushedFcn',@(~,~)ApplyPressed);
uiwait(fig)

    function ApplyPressed()
        A = [str2double(Ax.Value),str2double(Ay.Value)];
        B = [str2double(Bx.Value),str2double(By.Value)];
        uiresume(fig)
        close(fig)
    end

end