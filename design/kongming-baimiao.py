"""Baimiao Kongming: head and shoulders in thin brush line. Tapered strokes from centerlines."""
import math, random, sys

random.seed(3)

def smooth(pts, n=28):
    out = []
    P = [pts[0]] + pts + [pts[-1]]
    for i in range(1, len(P) - 2):
        p0, p1, p2, p3 = P[i-1], P[i], P[i+1], P[i+2]
        for k in range(n):
            t = k / n; t2, t3 = t*t, t*t*t
            x = 0.5*((2*p1[0]) + (-p0[0]+p2[0])*t + (2*p0[0]-5*p1[0]+4*p2[0]-p3[0])*t2 + (-p0[0]+3*p1[0]-3*p2[0]+p3[0])*t3)
            y = 0.5*((2*p1[1]) + (-p0[1]+p2[1])*t + (2*p0[1]-5*p1[1]+4*p2[1]-p3[1])*t2 + (-p0[1]+3*p1[1]-3*p2[1]+p3[1])*t3)
            out.append((x, y))
    out.append(pts[-1])
    return out

def stroke(pts, widths, jitter=0.35, cls="ink"):
    line = smooth(pts); n = len(line)
    def w_at(i):
        t = i / max(1, n - 1) * (len(widths) - 1)
        a = int(t); b = min(len(widths) - 1, a + 1)
        return widths[a] + (widths[b] - widths[a]) * (t - a)
    left, right = [], []
    for i, (x, y) in enumerate(line):
        if i == 0: dx, dy = line[1][0]-x, line[1][1]-y
        elif i == n-1: dx, dy = x-line[i-1][0], y-line[i-1][1]
        else: dx, dy = line[i+1][0]-line[i-1][0], line[i+1][1]-line[i-1][1]
        L = math.hypot(dx, dy) or 1
        nx, ny = -dy / L, dx / L
        w = max(0.12, w_at(i) / 2 + random.uniform(-jitter, jitter) * 0.4)
        left.append((x + nx*w, y + ny*w)); right.append((x - nx*w, y - ny*w))
    poly = left + right[::-1]
    d = "M" + " L".join(f"{x:.1f} {y:.1f}" for x, y in poly) + "Z"
    return f'<path d="{d}" class="{cls}"/>'

def fill(pts, cls, opacity=1):
    line = smooth(pts, 12)
    d = "M" + " L".join(f"{x:.1f} {y:.1f}" for x, y in line) + "Z"
    return f'<path d="{d}" class="{cls}" style="opacity:{opacity}"/>'

P = []; S = P.append
T = 0.4
M = 1.6   # the baimiao line
H = 2.4   # a heavier stroke

# ---------- cap: a coiled guanjin, lumpy silhouette, spiral at the front ----------
S(fill([(146,150),(134,110),(146,76),(176,52),(214,40),(254,38),(290,50),(314,82),(318,120),(306,150),(272,156),(230,150),(188,150)], "hair"))
S(fill([(150,112),(160,84),(186,64),(168,60),(148,80),(140,106)], "hair"))      # extra lobe, left
S(fill([(300,92),(312,72),(296,56),(282,62),(292,80)], "hair"))                 # lobe, right
# coils in paper color
for pts in [
    [(176,60),(212,48),(256,46),(292,58)],
    [(160,86),(190,68),(236,62),(282,70),(308,90)],
    [(150,114),(176,92),(220,84),(266,86),(300,104),(312,126)],
    [(154,138),(186,116),(228,108),(272,112),(304,132)],
    [(176,150),(208,134),(248,130),(290,142)],
]:
    S(stroke(pts, [T]+[1.1]*(len(pts)-2)+[T], cls="paperline"))
# the spiral, front-left
S(stroke([(172,122),(164,112),(170,102),(182,106),(184,118),(174,126),(162,118)], [T,1.0,1.1,1.1,1.0,0.9,T], cls="paperline"))
S(stroke([(146,150),(134,110),(146,76),(176,52),(214,40),(254,38),(290,50),(314,82),(318,120),(306,150)], [1.2,1.8,1.8,1.6,1.6,1.6,1.8,1.8,1.6,1.2]))
S(stroke([(150,152),(192,148),(236,146),(278,150),(306,150)], [1.2,1.6,1.6,1.6,1.2]))   # hairline / cap edge
# ribbon falling beside the left cheek
S(stroke([(140,150),(126,200),(120,260),(118,330)], [T,1.0,1.0,T]))
S(stroke([(148,152),(136,204),(130,262),(128,334)], [T,0.9,0.9,T]))

# ---------- face, three-quarters to the viewer's left ----------
S(stroke([(166,154),(152,196),(150,236),(162,272),(186,298),(216,308),(246,298),(264,270),(270,238),(270,214)], [1.0,M,M,M,H,M,M,M,1.2,T]))
S(stroke([(270,208),(284,212),(288,234),(278,252),(268,248)], [T,1.2,1.4,1.2,T]))    # ear
S(stroke([(274,220),(280,232),(276,242)], [T,1.0,T]))
# brows: long, fine, angled up toward the temples
S(stroke([(170,194),(186,180),(208,182)], [T,1.8,0.6]))
S(stroke([(176,192),(190,184),(206,186)], [T,0.7,T]))
S(stroke([(226,182),(250,172),(272,184)], [0.6,2.0,T]))
S(stroke([(232,186),(252,178),(268,188)], [T,0.7,T]))
# far eye: a narrow slit, iris a half-moon against the upper lid
S(fill([(186,203),(194,203),(196,207),(191,210),(185,208),(183,205)], "ink"))
S(stroke([(172,207),(184,202),(198,202),(206,208)], [T,2.4,2.0,T]))       # upper lid, heavy
S(stroke([(176,197),(188,193),(202,196)], [T,0.7,T]))                      # crease
S(stroke([(178,210),(190,212),(202,209)], [T,0.8,T]))                      # lower lid, close
# near eye: longer slit, same treatment
S(fill([(240,202),(252,202),(255,207),(249,211),(241,210),(237,205)], "ink"))
S(stroke([(226,208),(242,201),(262,201),(276,207)], [T,2.8,2.4,T]))
S(stroke([(230,196),(248,191),(268,195)], [T,0.7,T]))
S(stroke([(232,212),(250,215),(268,210)], [T,0.9,T]))
S(stroke([(222,207),(228,201)], [T,0.8]))
# nose turned to the left
S(stroke([(220,198),(212,222),(204,246)], [T,1.0,1.0]))
S(stroke([(196,250),(204,258),(220,256),(228,248)], [T,1.4,1.2,T]))
S(stroke([(192,246),(196,254)], [T,0.9]))
# mouth, shifted left
S(stroke([(198,272),(212,275),(230,270)], [T,1.4,T]))
S(stroke([(204,281),(218,281)], [T,0.8]))
# moustache: thin strands
for k in range(4):
    S(stroke([(206-k*2,266),(192-k*4,276+k*3),(180-k*6,296+k*6)], [0.9,0.8,T]))
    S(stroke([(224+k*2,266),(240+k*4,276+k*3),(252+k*5,296+k*6)], [0.9,0.8,T]))
# goatee: long thin strands
for dx, L in [(-18,80),(-13,92),(-8,104),(-3,114),(2,116),(7,110),(12,100),(17,86)]:
    S(stroke([(214+dx*0.4,304),(214+dx,304+L*0.5),(212+dx*1.5,304+L)], [1.0,0.8,T]))
# beard along the jaw
for (sx,sy,ex,ey) in [(166,280,156,316),(176,294,166,334),(186,302,178,340),(248,296,254,330),(258,282,266,316),(264,266,274,300)]:
    S(stroke([(sx,sy),((sx+ex)/2,(sy+ey)/2+2),(ex,ey)], [0.9,0.8,T]))

# ---------- neck, collar, shoulders ----------
S(stroke([(190,300),(188,320),(178,334)], [T,M,1.0]))
S(stroke([(250,296),(254,318),(262,332)], [T,M,1.0]))
# layered cross collar, close to the neck
S(stroke([(120,350),(168,358),(212,380),(252,356),(318,338)], [1.2,M,H,M,1.2]))
S(stroke([(132,362),(176,370),(212,392),(250,368),(306,352)], [T,1.2,1.6,1.2,T]))
S(stroke([(144,374),(184,382),(212,404),(246,380),(294,366)], [T,1.0,1.4,1.0,T]))
S(stroke([(212,380),(214,450),(212,520)], [1.6,1.4,1.0]))
# shoulders, sleeves
S(stroke([(120,350),(84,360),(56,388),(40,440),(34,520)], [1.4,H,H,M,1.2]))
S(stroke([(318,338),(350,350),(376,378),(388,430),(396,520)], [1.4,H,H,M,1.2]))
S(stroke([(70,398),(86,430),(80,470),(74,520)], [T,1.2,1.2,T]))
S(stroke([(120,420),(124,470),(118,520)], [T,1.0,T]))
S(stroke([(330,398),(322,440),(330,480),(336,520)], [T,1.2,1.2,T]))
S(stroke([(290,420),(292,470),(298,520)], [T,1.0,T]))
S(stroke([(160,440),(150,480),(152,520)], [T,1.0,T]))
S(stroke([(268,440),(276,480),(272,520)], [T,1.0,T]))
S(stroke([(350,350),(374,344),(390,352)], [T,1.2,T]))
S(stroke([(374,344),(380,330)], [T,1.0]))

out = '\n'.join(P)
open('/private/tmp/claude-501/-Users-techin-CodingProject-personal-minetimer/4b3102d8-364a-44f1-a38c-2443d05f4630/scratchpad/baimiao.svgfrag','w').write(out)
print(len(P), 'strokes')
