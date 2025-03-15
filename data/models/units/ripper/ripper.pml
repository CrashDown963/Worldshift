<?xml version="1.0"?>
<library id="Ripper_BH01_optimize" type="physics">
 <scenedesc source="3dsmax">
  <eye>2.15852 -2.83689 2.97602</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <groundplane>0.0 0.0 1.0 0.0</groundplane>
  <lookat>1.5602 -2.24908 2.43152</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Box01">
   <mass>10.0</mass>
   <orientation>0.707107 0.0 0.0 0.707107</orientation>
   <position>4.16636e-005 0.10876 0.791162</position>
   <shape id="shape_Box01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Box01_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.05</position>
    <geometry id="Box01_geom">
     <convex facecount="0">
      <vertices count="16">
         -0.0529868 0.0109784 0.255441,
         0.0529035 0.0109784 0.255441,
         -0.0453608 0.122872 0.217525,
         0.0303453 -0.230158 0.176041,
         0.110237 0.116556 -0.109265,
         0.0914915 0.15535 -0.0846421,
         -0.0918557 0.15535 -0.0846421,
         -0.0510095 -0.138887 -0.0501928,
         0.0509262 -0.138887 -0.0501928,
         0.0685238 0.133671 -0.114585,
         -0.0686071 0.00253779 -0.147516,
         0.0685238 0.00253779 -0.147516,
         0.167269 -0.0241935 -0.0302949,
         -0.167353 -0.0241935 -0.0302949,
         -0.167353 -0.0482883 0.0114387,
         -0.178877 -9.85437e-005 0.0114387,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone01">
   <mass>10.0</mass>
   <orientation>0.59024 -0.196463 -0.712572 0.324438</orientation>
   <position>-0.179973 0.109245 0.792181</position>
   <shape id="shape_Bone01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone01_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone01_geom">
     <convex facecount="0">
      <vertices count="14">
         -0.0780097 0.069685 -0.0389626,
         -0.0791878 -0.0498597 -0.0389625,
         -0.0791878 -0.0498597 0.0258428,
         -0.0780097 0.069685 0.0258428,
         0.129666 -0.119566 -0.0294866,
         0.601828 0.000302958 0.0718918,
         0.585622 -0.0697326 0.0685403,
         0.526043 0.0926045 0.0366079,
         0.419783 0.110102 -0.0471608,
         0.526043 0.0926045 -0.0448628,
         0.51837 0.0554482 0.078515,
         0.601828 0.000302976 -0.0801467,
         0.420109 0.0671931 -0.0914317,
         0.585622 -0.0697326 -0.076795,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone02">
   <mass>10.0</mass>
   <orientation>0.610294 0.120508 -0.779856 -0.0696002</orientation>
   <position>-0.223245 -0.2148 0.459079</position>
   <shape id="shape_Bone02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone02_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone02_geom">
     <convex facecount="0">
      <vertices count="14">
         0.402016 0.0165628 0.0297209,
         0.39075 -0.0829558 -0.0362832,
         0.39075 -0.0829557 0.0297209,
         0.332926 -0.104787 -0.0362832,
         0.343439 0.0983656 -0.0385227,
         0.346398 0.0594744 -0.0974319,
         0.291022 -0.0521449 -0.0974319,
         0.348842 0.0605822 0.0909079,
         0.00107569 -0.0842608 0.0514842,
         -0.0658483 0.0466455 0.0514842,
         -0.0701758 -0.0381271 0.0514842,
         -0.0658482 0.0466454 -0.0571519,
         -0.0701758 -0.0381272 -0.0571519,
         0.272622 -0.0494002 0.115908,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone08">
   <mass>10.0</mass>
   <orientation>0.7276 -0.240053 -0.624818 0.150254</orientation>
   <position>0.178181 0.109245 0.792181</position>
   <shape id="shape_Bone08">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone08_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone08_geom">
     <convex facecount="0">
      <vertices count="15">
         -0.0780097 0.069685 0.0371702,
         -0.0791878 -0.0498598 0.0371702,
         -0.0791878 -0.0498598 -0.0276352,
         -0.0780097 0.069685 -0.0276352,
         0.129666 -0.119566 0.0276942,
         0.129666 -0.119566 -0.0259842,
         0.601828 0.000302905 -0.0736843,
         0.585622 -0.0697326 -0.0703327,
         0.526043 0.0926045 -0.0384004,
         0.419783 0.110102 0.0453683,
         0.526043 0.0926044 0.0430704,
         0.51837 0.0554482 -0.0803074,
         0.601828 0.000302915 0.0783542,
         0.420109 0.0671931 0.0896393,
         0.585622 -0.0697326 0.0750025,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone09">
   <mass>10.0</mass>
   <orientation>-0.734681 -0.217417 0.599047 0.232628</orientation>
   <position>0.2267 -0.141428 0.401485</position>
   <shape id="shape_Bone09">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone09_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone09_geom">
     <convex facecount="0">
      <vertices count="13">
         0.402016 0.0165628 -0.0315133,
         0.39075 -0.0829558 0.0344908,
         0.39075 -0.0829558 -0.0315133,
         0.332926 -0.104787 0.0344908,
         0.343439 0.0983657 0.0367302,
         0.346399 0.0594744 0.0956395,
         0.291022 -0.0521449 0.0956395,
         0.348842 0.0605822 -0.0927004,
         0.220301 -0.0868408 -0.116627,
         -0.0658482 0.0466454 -0.0532766,
         -0.0701757 -0.0381271 -0.0532766,
         -0.0658482 0.0466454 0.0553595,
         -0.0701757 -0.0381271 0.0553596,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Box04">
   <mass>30.0</mass>
   <orientation>0.298836 0.298836 -0.640856 0.640856</orientation>
   <position>-0.000111391 0.0323632 1.12045</position>
   <shape id="shape_Box04">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Box04_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Box04_geom">
     <convex facecount="0">
      <vertices count="17">
         -0.124804 0.198514 -0.129949,
         -0.191207 0.234825 0.0384925,
         -0.0344646 0.000111461 0.447323,
         0.185743 0.198514 0.384285,
         -0.280552 -0.1354 0.0816025,
         -0.124804 -0.198291 -0.129949,
         -0.183543 -0.1354 0.296939,
         -0.0154151 -0.210327 0.356359,
         0.0998189 -0.17171 0.441121,
         -0.0404 -0.0602656 -0.249017,
         -0.0404 0.0604872 -0.249017,
         -0.116235 -0.0405425 -0.254798,
         -0.222875 0.0741256 0.287236,
         0.0437662 -0.274454 0.137198,
         -0.304603 0.0800065 -0.0397669,
         -0.25389 -0.0885116 -0.140042,
         0.290233 0.0584055 0.178289,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone15">
   <mass>10.0</mass>
   <orientation>0.562812 0.176826 -0.747874 -0.304399</orientation>
   <position>-0.267027 -0.103128 1.17437</position>
   <shape id="shape_Bone15">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone15_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone15_geom">
     <convex facecount="0">
      <vertices count="18">
         0.375259 -0.0420276 0.0413332,
         0.350351 0.0327418 0.0408906,
         0.35307 0.0331922 -0.0373588,
         0.220116 0.0468112 -0.0418913,
         0.204269 -0.0709635 -0.0431167,
         0.377979 -0.0415766 -0.0369226,
         0.359925 -0.084683 -0.0178537,
         0.358633 -0.0848874 0.0204689,
         -0.140867 -0.0918902 0.0154672,
         -0.14676 0.0522229 0.0160372,
         0.110018 -0.0972463 0.0614691,
         0.102752 0.0804638 0.0621719,
         -0.164187 0.0197808 0.0280089,
         -0.160841 -0.0620601 0.0276851,
         -0.157336 0.0111393 0.00854093,
         -0.13525 -0.0788989 -0.00222862,
         -0.154745 -0.052662 0.00836324,
         -0.140074 0.0401492 -0.00193658,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone16">
   <mass>10.0</mass>
   <orientation>0.462426 -0.360794 -0.687593 0.428027</orientation>
   <position>-0.335074 0.142657 0.898611</position>
   <shape id="shape_Bone16">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone16_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone16_geom">
     <convex facecount="0">
      <vertices count="18">
         -0.0500907 0.0389044 0.0493165,
         -0.0503387 0.0362659 -0.0465052,
         -0.0473694 -0.147063 -0.00153607,
         -0.0473281 -0.146621 0.0144888,
         -0.0590638 -0.13777 -0.00176159,
         -0.0590223 -0.137328 0.0142632,
         0.299922 -0.0803212 -0.0343818,
         0.347779 -0.01075 0.0398336,
         0.347582 -0.0128481 -0.0363631,
         0.347949 -0.0373352 -0.0356898,
         0.348146 -0.0352372 0.0405065,
         0.321038 -0.0722057 -0.03466,
         0.30662 0.0236695 0.0603874,
         0.339969 -0.0181435 0.0568268,
         0.305812 -0.0664994 0.0582467,
         0.306312 0.0203942 -0.0585666,
         0.305528 -0.0695202 -0.0514633,
         0.339685 -0.0211643 -0.0528832,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone30">
   <mass>10.0</mass>
   <orientation>0.0571647 -0.780306 -0.0324378 0.621934</orientation>
   <position>0.268175 -0.103128 1.17437</position>
   <shape id="shape_Bone30">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone30_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone30_geom">
     <convex facecount="0">
      <vertices count="18">
         -0.375063 0.0421288 -0.040165,
         -0.350155 -0.0326406 -0.039738,
         -0.352867 -0.0331051 0.0385116,
         -0.219912 -0.0467246 0.0430294,
         -0.204065 0.0710499 0.0442746,
         -0.377775 0.0416638 0.038091,
         -0.359724 0.0847736 0.0190283,
         -0.358435 0.0849849 -0.0192945,
         0.141066 0.0919879 -0.0143368,
         0.146958 -0.0521252 -0.0149332,
         -0.109824 0.0973518 -0.0603149,
         -0.102558 -0.0803582 -0.0610504,
         0.164384 -0.0196809 -0.0269007,
         0.161038 0.0621601 -0.0265619,
         0.157535 -0.0110428 -0.00743056,
         0.13545 0.0789934 0.00335716,
         0.154944 0.0527584 -0.00724116,
         0.140274 -0.0400547 0.00304331,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone31">
   <mass>10.0</mass>
   <orientation>0.0272633 0.0480406 -1.12607 0.851293</orientation>
   <position>0.350758 -0.0544579 0.811197</position>
   <shape id="shape_Bone31">
    <orientation>0.0 0.0 0.0 1.99579</orientation>
    <physicsmaterial id="Bone31_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Bone31_geom">
     <convex facecount="0">
      <vertices count="18">
         0.0502971 -0.0390323 -0.0481603,
         0.0505337 -0.0364094 0.0476618,
         0.0475701 0.146927 0.0027221,
         0.0475307 0.146488 -0.0133028,
         0.0592644 0.137633 0.0029475,
         0.0592249 0.137195 -0.0130774,
         -0.299726 0.0801801 0.0355157,
         -0.347574 0.010621 -0.0387167,
         -0.347386 0.0127067 0.0374803,
         -0.347752 0.037194 0.036811,
         -0.347941 0.0351084 -0.0393857,
         -0.320842 0.0720645 0.0357901,
         -0.306412 -0.0237952 -0.0592712,
         -0.339761 0.0180173 -0.0557077,
         -0.305605 0.0663734 -0.0571157,
         -0.306118 -0.0205392 0.0596833,
         -0.305334 0.0693764 0.0525948,
         -0.339491 0.0210203 0.0540028,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Box07">
   <mass>10.0</mass>
   <orientation>0.627211 0.627211 -0.326506 0.326505</orientation>
   <position>-0.000111188 -0.397386 1.26943</position>
   <shape id="shape_Box07">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Box07_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <geometry id="Box07_geom">
     <convex facecount="0">
      <vertices count="8">
         0.0472544 -0.0676612 0.258595,
         -0.0933497 -0.0782768 0.0930276,
         -0.0701776 -0.0928425 -0.084493,
         0.0840929 -0.0948384 -0.0706895,
         0.0472544 0.0683911 0.258595,
         -0.0701778 0.0935727 -0.0844928,
         0.0840929 0.0955683 -0.0706896,
         -0.060738 0.0203578 0.203211,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Box04" class="novodex" id="Joint_Box04" parent="#Box01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-1.4386e-007 1.0 5.83282e-007</x>
    <y>-0.766045 -4.85129e-007 0.642788</y>
    <z>0.642788 -3.68817e-007 0.766045</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000179709 0.386629 0.0897017</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Box07" class="novodex" id="Joint_Box07" parent="#Box04">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.258819 2.46852e-007 0.965926</x>
    <y>2.98988e-007 1.0 -3.35673e-007</y>
    <z>-0.965926 3.75679e-007 0.258819</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.19034 0.0 0.498981</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <rigidbody id="groundplane">
   <dynamic>0</dynamic>
   <mass>0</mass>
   <shape>
    <geometry>
     <plane>
      <d>0</d>
      <normal>0.0 0.0 1.0</normal>
     </plane>
    </geometry>
   </shape>
  </rigidbody>
 </physicsmodel>
</library>
