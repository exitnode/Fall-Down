--fall down
--by michael clemens
--clone of the atari version from aaron curtis

--game
--x,y,spritefront,spritel,spriter,
--spritestate,playernumber,color,opp
passby=false
candie=false
blue={28,-20,4,2,3,"f",0,9,2,0}
red={100,-20,7,5,6,"f",1,10,1,0}
players={blue,red}
timecode=0
lines={
 --y,color,elements
 {-100,11,{11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}},
 {-100,11,{11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}},
 {-100,11,{11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}},
 {-100,11,{11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11}}
}
linecount=0

function ispingap(playery)
 pisingap=false
 for l=1,4 do
  -- if player is inbetween a line
  if (playery > lines[l][1]-3 and playery < lines[l][1]+3) then
   pisingap=true
  end
 end
 return pisingap
end

--todo: define range instead of point
function playersonsamelevel()
 result=false
 if (red[2]-4 < blue[2])
  and blue[2] < red[2]+4 then
  result=true
 end
 return result
end

function moveplayer(p) 
  opponent=players[p[9]]
  --left
  if btn (0,p[7]) then
   --check if player is in between a line
   if (ispingap(p[2])==false) then
    --if ((opponent[1]+7 < p[1]+2) 
    if (p[1]!=opponent[1]+4
    or not playersonsamelevel())
    or passby then
     p[1]-=2
    end
   end
   if (p[1]<-8) then
    p[1]=128
   end
   p[6]="l"
  --right
  elseif btn(1,p[7]) then
   --check if player is in between a line
   if (ispingap(p[2])==false) then
    --if ((opponent[1]+2 > p[1]+6)
    if (p[1]!=opponent[1]-4 
    or not playersonsamelevel())
    or passby then
   	 p[1]+=2
   	end
   end
   if (p[1]>128) then
    p[1]=-4
   end
   p[6]="r"
  else
   p[6]="f"
  end
end
	
--lets fall down the player
function falldown(player)
  drop=true
  --check all 4 lines
  for l=1,4 do
   -- if player stands on a line
   if (player[2]+6==lines[l][1]) then
    -- and there is no gap: dont drop
    -- get one or both tile numbers under players feet
    pposl=flr(player[1]/8)+1
    pposr=flr((player[1]+8)/8)+1
    if (lines[l][3][pposl]!=12 
    or lines[l][3][pposr]!=12) then
     drop=false
    end
   end
   --increment player score and change line color
   if (player[2]==lines[l][1] and lines[l][2]==11) then
    for y=1,16 do
     if lines[l][3][y]==11 then
      lines[l][3][y]=player[8]
     end
    end
    player[10]+=1
   end
  end
  --let player fall or not
  if (drop==true) 
  and player[2]<120 then 
   player[2]+=1
  else
   player[2]-=1
  end
	 --end
end

--draws 4 visible lines
function drawline()
 --let lines appear on bottom of screen

 for i=40,160,40 do 
		if (linecount==i) then
   resetline(lines[linecount/40])
  end 
 end
 if (linecount==160) then
 	linecount=0
 end
 --draw the lines 
 for l=1,4 do
  for i=1,16 do
   spr(lines[l][3][i],(i-1)*8,lines[l][1])
  end
  lines[l][1]-=1
 end 
 linecount+=1
end

--begins a line on white on bottom of page
function resetline(l)
 c=11
 l[3]={c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c}
 l[1]=128
 gaps={flr(rnd(16)),flr(rnd(16)),flr(rnd(16))}
 for x=1,flr(rnd(2)+2) do
  l[3][gaps[x]]=12
  l[3][gaps[x]+1]=12
 end
end

function drawdots()
 --todo
end

function drawheader()
 rectfill(0,0,128,15,0)
 if blue[10]!=-1 then
  print(blue[10],7,5,12)
 else
  print("dead",7,5,12)
 end
 if red[10]!=-1 then
  print(red[10],112,5,8)
 else
  print("dead",112,5,8)
 end 
end

function drawplayers()
 for p in all(players) do
  if p[10]!=-1 then
   if (p[6]=="r") then
    spr(p[5],p[1],p[2])
   elseif (p[6]=="l") then
    spr(p[4],p[1],p[2])
   else
    spr(p[3],p[1],p[2])
   end
  end  
 end
end

function checkdeath(p)
 --for p in all(players) do
  if p[2]<0 and candie then
   p[10]=-1
  elseif p[2]>0 and not candie then
   candie=true
  end
 --end
end

function	drawtitlescreen()
	--todo		
end

function _update()
 for p in all(players) do
  if p[10]!=-1 then
   moveplayer(p)
   falldown(p)
   checkdeath(p)
   timecode+=1
  end
 end
end


function _draw()
 -- clear the screen
 rectfill(0,0, 128,128, 1)
 
 drawline()
 drawdots()
 drawplayers()
 drawheader()
 --drawtitlescreen()
 --print (flr(blue[1]/8),50,50,6)
end	
