function game2048
clc;clear;
global GUI;
global score;
global best;
global gameover;
global squaremap;
global colorlist;
global fontsizelist;

global drawBkgHdl;
global drawSquareBkgHdl;
global drawSquareHdl;
global GameOver1Hdl;
global GameOver2Hdl;
global GameOver3Hdl;
global GameOver4Hdl;
global GameOver5Hdl;
global GameOver6Hdl;
global Restart1Hdl;
global Text1Hdl;
global Text2048Hdl;

global textScore1Hdl;
global textBest1Hdl;

global Score1Hdl;
global Best1Hdl;
%==========================================================================
init()
    function key(~,event)
        temp_map=squaremap;
        switch event.Key
            case 'uparrow'
                temp_map=moveevent(temp_map(:,4:-1:1));
                temp_map=temp_map(:,4:-1:1);
            case 'downarrow'
                temp_map=moveevent(temp_map);
            case 'rightarrow'
                temp_map=temp_map';
                temp_map=moveevent(temp_map(:,4:-1:1));
                temp_map=temp_map(:,4:-1:1);
                temp_map=temp_map';
                
            case 'leftarrow'
                temp_map=moveevent(temp_map');
                temp_map=temp_map';
        end
        if any(any(squaremap~=temp_map))
            squaremap=temp_map;
            createNewNum()
            drawSquare()
        end
    end

    function temp_matrix=moveevent(temp_matrix)
        for i = 1: 4
            temp_array=temp_matrix(i,:);
            temp_array(temp_array==0)=[];

            for j = 1: (length(temp_array)-1)
                if temp_array(j)==temp_array(j+1)
                    temp_array(j)=temp_array(j)+temp_array(j+1);
                    temp_array(j+1)=0;
                end
            end

            temp_array(temp_array==0)=[];
            temp_array((length(temp_array)+1):4)=0;
            temp_matrix(i,:)=temp_array;
        end
    end

    function createNewNum(~,~)
        zerospos=find(squaremap==0);
        temp_pos=zerospos(randi(length(zerospos)));
        temp_num=randi(2)*2;
        squaremap(temp_pos)=temp_num;
    end

    function drawSquare(~,~)
        judge()
        score=sum(sum(squaremap));
        set(textScore1Hdl,'string',num2str(score));
        for i=1:4
            for j=1:4
                temp_num=log(squaremap(i,j))/log(2);
                temp_num(temp_num<0)=0;
                set(drawSquareHdl(i,j),'backgroundcolor',colorlist(temp_num+1,:));    
                switch 1
                    case squaremap(i,j)==0,set(drawSquareHdl(i,j),'string','');   
                    case squaremap(i,j)<=4&&squaremap(i,j)>0,set(drawSquareHdl(i,j),...
                                                            'string',num2str(squaremap(i,j)),...
                                                            'fontsize',fontsizelist(temp_num+1),...
                                                            'foregroundcolor',[0.4667 0.4314 0.3961]);  
                    case squaremap(i,j)>4,set(drawSquareHdl(i,j),...
                                          'string',num2str(squaremap(i,j)),...
                                          'fontsize',fontsizelist(temp_num+1),...
                                          'foregroundcolor','w');  
                end
            end
        end
    end
%==========================================================================
    function judge(~,~)
        temp_judge_zeros=sum(sum(squaremap==0));
        temp_judge_row=any(any(squaremap(1:3,:)==squaremap(2:4,:)));
        temp_judge_col=any(any(squaremap(:,1:3)==squaremap(:,2:4)));
        if temp_judge_row+temp_judge_col+temp_judge_zeros==0
            gameover=1;
            gameOver()
        end
    end

    function gameOver(~,~)
        best=max([best,score]);
        save best.mat best -append
        set(GameOver1Hdl,'visible','on');
        set(GameOver2Hdl,'visible','on');
        set(GameOver3Hdl,'visible','on');
        set(GameOver4Hdl,'visible','on');
        set(GameOver5Hdl,'visible','on');
        set(GameOver6Hdl,'visible','on');
        set(GameOver4Hdl,'string',{['Best : ',num2str(best)];['Score : ',num2str(score)]});
    end

    function savepic(~,~)
        [filename, pathname] = uiputfile({'*.jpg;*.png','All Image Files';...
            '*.jpg','JPG';'*.png','PNG' });
        saveas(gcf,[pathname,filename])
    end

    function restart(~,~)
        best=max([best,score]);
        save best.mat best -append  
        close all;
        clc;clear;init()
    end
%==========================================================================
    function init(~,~)
        GUI.fig=figure('units','pixels',...
            'position',[560 50 320+80 460+115],...
            'Color',[0.9804 0.9725 0.9373],...
            'tag','fig',...
            'Numbertitle','off',...
            'menubar','none',...
            'name','2048Game',...
            'resize','off');
        drawBkgHdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','',...
            'position',[0 0 320+80 460+115],...
            'backgroundcolor',[0.9804 0.9725 0.9373]);
        drawSquareBkgHdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','',...
            'position',[20 20 320+80-40 320+80-40],...
            'backgroundcolor',[0.7333 0.6784 0.6275]);
        for i=1:4
            for j=1:4
                drawSquareHdl(i,j)=uicontrol('parent',GUI.fig,...
                        'style','edit',...
                        'string','',...
                        'horizontalalign','center',...
                        'Enable','inactive',...
                        'FontWeight','bold',...
                        'position',[30+(i-1)*(350/4) 30+(j-1)*(350/4) 350/4-10 350/4-10],...
                        'backgroundcolor',[0.8039 0.7569 0.7059]);
            end
        end
        Restart1Hdl=uicontrol('parent',GUI.fig,...
            'style','pushbutton',...
            'string','New Game',...
            'FontWeight','bold',...
            'horizontalalign','center',...
            'position',[320+80-20-140 320+80-20+25 140 50],...
            'backgroundcolor',[0.5608 0.4784 0.4000],...
            'foregroundcolor','w',...
            'fontsize',16,...
            'callback',@restart);
        Text1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string',{'~~~~'; '~~~~'},...
            'horizontalalign','left',...
            'position',[20 320+80-20+25 200 50],...
            'backgroundcolor',[0.9804 0.9725 0.9373],...
            'foregroundcolor',[0.4667 0.4314 0.3961],...
            'fontsize',14);
        Text2048Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','2048',...
            'horizontalalign','left',...
            'position',[22 480 200 50],...
            'backgroundcolor',[0.9804 0.9725 0.9373],...
            'foregroundcolor',[0.4667 0.4314 0.3961],...
            'FontWeight','bold',...
            'fontsize',27);
        Score1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','SCORE',...
            'horizontalalign','center',...
            'position',[380-170 320+80-20+25+70 80 70],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor',[0.9333 0.8941 0.8549],...
            'FontWeight','bold',...
            'fontsize',15);
        Best1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','BEST',...
            'horizontalalign','center',...
            'position',[380-80 320+80-20+25+70 80 70],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor',[0.9333 0.8941 0.8549],...
            'FontWeight','bold',...
            'fontsize',15);
        textScore1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','0',...
            'horizontalalign','center',...
            'position',[380-170 320+80-20+25+70 80 40],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'fontsize',14);
        textBest1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','0',...
            'horizontalalign','center',...
            'position',[380-80 320+80-20+25+70 80 40],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'fontsize',14);
        
        
        
        GameOver1Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','',...
            'horizontalalign','center',...
            'position',[0 200 320+80 200-20],...
            'backgroundcolor',[0.7765 0.7647 0.7412],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'visible','off',...
            'fontsize',14);
        GameOver2Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','',...
            'horizontalalign','center',...
            'position',[0 203 320+80 200-6-20],...
            'backgroundcolor',[0.9804 0.9725 0.9333],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'visible','off',...
            'fontsize',14);
        GameOver3Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','Game Over',...
            'horizontalalign','center',...
            'position',[0 203 320+80 200-6-20],...
            'backgroundcolor',[0.9804 0.9725 0.9333],...
            'foregroundcolor',[0.9686 0.3686 0.2431],...%[0.4667 0.4314 0.3961],...
            'FontWeight','bold',...
            'visible','off',...
            'fontsize',20);
        GameOver4Hdl=uicontrol('parent',GUI.fig,...
            'style','text',...
            'string','',...
            'horizontalalign','center',...
            'position',[0 203 320+80 150-20],...
            'backgroundcolor',[0.9804 0.9725 0.9333],...
            'foregroundcolor',[0.4667 0.4314 0.3961],...
            'FontWeight','bold',...
            'visible','off',...
            'fontsize',14);
        GameOver5Hdl=uicontrol('parent',GUI.fig,...
            'style','pushbutton',...
            'string','restart',...
            'horizontalalign','center',...
            'position',[320+80-80-100 203+30 100 30],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'visible','off',...
            'callback',@restart,...
            'fontsize',10);
        GameOver6Hdl=uicontrol('parent',GUI.fig,...
            'style','pushbutton',...
            'string','save picture',...
            'horizontalalign','center',...
            'position',[80 203+30 100 30],...
            'backgroundcolor',[0.7333 0.6784 0.6275],...
            'foregroundcolor','w',...
            'FontWeight','bold',...
            'visible','off',...
            'callback',@savepic,...
            'fontsize',10);
        
        if ~exist('best.mat')
            best=0;
            save('best.mat', 'best');
        end
        data=load('best.mat');
        best=data.best;
        colorlist=[ 0.8039    0.7569    0.7059
                    0.9333    0.8941    0.8549
                    0.9373    0.8784    0.8039
                    0.9608    0.6863    0.4824
                    0.9529    0.5922    0.4078
                    0.9529    0.4902    0.3725
                    0.9686    0.3686    0.2431
                    0.9255    0.8118    0.4510
                    0.9373    0.7882    0.3922
                    0.9333    0.7804    0.3216
                    0.9216    0.7686    0.2627
                    0.9255    0.7608    0.1804
                    0.9412    0.4078    0.4157
                    0.9216    0.3137    0.3451
                    0.9451    0.2549    0.2627
                    0.4392    0.7020    0.8157
                    0.3765    0.6353    0.8745
                    0.0902    0.5098    0.7843];
        fontsizelist=[12 24 24 24 24 24 24 24 24 24 22 22 22 22 20 20 20 16];
        set(textBest1Hdl,'string',num2str(best));
        squaremap=zeros(4,4);
        score=0;   
        gameover=0;
        createNewNum()
        createNewNum()
        drawSquare()
        set(gcf, 'KeyPressFcn', @key); 
    end
end