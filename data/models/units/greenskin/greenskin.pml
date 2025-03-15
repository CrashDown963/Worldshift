<?xml version="1.0"?>
<library id="Green_NEW_PhysX" type="physics">
 <scenedesc source="3dsmax">
  <eye>-5.65995 2.43149 1.1685</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-4.72503 2.08194 1.22955</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>40.0</mass>
   <orientation>-0.0184104 0.00219815 -0.705429 0.708538</orientation>
   <position>-0.00468746 -0.0937737 1.27073</position>
   <shape id="shape_Bip01_Spine">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine_geom">
     <capsule>
      <p0>0.0 0.0 0.2499</p0>
      <p1>0.0 0.0 0.6115</p1>
      <radius>0.2499</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>20.0</mass>
   <orientation>-0.657255 0.750491 -0.0540912 -0.0430465</orientation>
   <position>-0.157266 -0.0943938 1.27519</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.15</p0>
      <p1>0.0 0.0 0.41</p1>
      <radius>0.15</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>10.0</mass>
   <orientation>0.655917 -0.745501 -0.0684297 -0.0965319</orientation>
   <position>-0.153541 -0.173456 0.706829</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.58</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>20.0</mass>
   <orientation>-0.7398 0.661335 -0.123288 -0.0114764</orientation>
   <position>0.147891 -0.0931537 1.26628</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.15</p0>
      <p1>0.0 0.0 0.41</p1>
      <radius>0.15</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>10.0</mass>
   <orientation>-0.748448 0.646599 0.0482768 0.139302</orientation>
   <position>0.24386 -0.196475 0.710028</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.58</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>10.0</mass>
   <orientation>0.878854 0.43734 0.132616 0.136975</orientation>
   <position>0.256598 -0.0809176 2.03587</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.275</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>10.0</mass>
   <orientation>-0.821922 -0.304624 0.338255 -0.342393</orientation>
   <position>0.409213 -0.134872 1.63486</position>
   <shape id="shape_Bip01_L_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>10.0</mass>
   <orientation>-0.540333 -0.805032 0.0595559 0.237521</orientation>
   <position>-0.379644 -0.041835 1.98326</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.275</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>10.0</mass>
   <orientation>-0.408933 -0.796036 0.358162 -0.26612</orientation>
   <position>-0.572855 0.0276994 1.60268</position>
   <shape id="shape_Bip01_R_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.3</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>20.0</mass>
   <orientation>-0.00839976 -0.00298973 -0.713743 0.70035</orientation>
   <position>-0.0689199 -0.0609128 2.22004</position>
   <shape id="shape_Bip01_Head">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Head_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 1.33514e-007 0.0669579</position>
    <geometry id="Bip01_Head_geom">
     <sphere>
      <radius>0.14469</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail1">
   <mass>2.0</mass>
   <orientation>-0.701117 -0.686918 -0.133914 0.136549</orientation>
   <position>-0.0634061 0.170446 2.28056</position>
   <shape id="shape_Bip01_Ponytail1">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail1_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail1_geom">
     <capsule>
      <p0>0.0 0.0 0.0694304</p0>
      <p1>0.0 0.0 0.240171</p1>
      <radius>0.0694304</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail11">
   <mass>2.0</mass>
   <orientation>-0.709909 -0.695981 -0.0743554 0.0781753</orientation>
   <position>-0.0633546 0.285723 1.99533</position>
   <shape id="shape_Bip01_Ponytail11">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail11_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail11_geom">
     <capsule>
      <p0>0.0 0.0 0.0870645</p0>
      <p1>0.0 0.0 0.253207</p1>
      <radius>0.0870645</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail12">
   <mass>2.0</mass>
   <orientation>-0.710884 -0.696921 -0.0648811 0.0688152</orientation>
   <position>-0.0643819 0.353003 1.68788</position>
   <shape id="shape_Bip01_Ponytail12">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail12_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail12_geom">
     <capsule>
      <p0>0.0 0.0 0.0862658</p0>
      <p1>0.0 0.0 0.219996</p1>
      <radius>0.0862658</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail13">
   <mass>2.0</mass>
   <orientation>-0.708374 -0.694438 -0.0875154 0.0911225</orientation>
   <position>-0.0654998 0.408115 1.39916</position>
   <shape id="shape_Bip01_Ponytail13">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail13_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail13_geom">
     <capsule>
      <p0>0.0 0.0 0.0798757</p0>
      <p1>0.0 0.0 0.2186</p1>
      <radius>0.0798757</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail14">
   <mass>2.0</mass>
   <orientation>-0.701729 -0.687051 -0.132123 0.134466</orientation>
   <position>-0.0662341 0.481184 1.11611</position>
   <shape id="shape_Bip01_Ponytail14">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail14_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail14_geom">
     <capsule>
      <p0>0.0 0.0 0.0798757</p0>
      <p1>0.0 0.0 0.190027</p1>
      <radius>0.0798757</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail15">
   <mass>2.0</mass>
   <orientation>-0.700052 -0.685845 -0.139341 0.141872</orientation>
   <position>-0.0662197 0.57883 0.870599</position>
   <shape id="shape_Bip01_Ponytail15">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail15_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail15_geom">
     <capsule>
      <p0>0.0 0.0 0.0798757</p0>
      <p1>0.0 0.0 0.190027</p1>
      <radius>0.0798757</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail16">
   <mass>2.0</mass>
   <orientation>-0.694272 -0.679811 -0.166154 0.168035</orientation>
   <position>-0.0660975 0.677134 0.637833</position>
   <shape id="shape_Bip01_Ponytail16">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail16_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail16_geom">
     <capsule>
      <p0>0.0 0.0 0.0798757</p0>
      <p1>0.0 0.0 0.209471</p1>
      <radius>0.0798757</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Ponytail17">
   <mass>2.0</mass>
   <orientation>-0.684455 -0.67007 -0.202524 0.203745</orientation>
   <position>-0.0655938 0.7898 0.419506</position>
   <shape id="shape_Bip01_Ponytail17">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Ponytail17_mat">
     <dynamicfriction>0.6</dynamicfriction>
     <restitution>0.2</restitution>
     <staticfriction>0.6</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Ponytail17_geom">
     <capsule>
      <p0>0.0 0.0 0.0798757</p0>
      <p1>0.0 0.0 0.209471</p1>
      <radius>0.0798757</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>-0.01841 0.00219809 -0.705428 0.708539</orientation>
   <position>-0.00468746 -0.0937737 1.27073</position>
   <shape id="shape_Bip01_Pelvis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis_geom">
     <sphere>
      <radius>0.0295858</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_Gun">
   <mass>7.5</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.31259 -0.35749 1.5788</position>
   <shape id="shape_Bone_Gun">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_Gun_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.3</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.00244998</position>
    <geometry id="Bone_Gun_geom">
     <box>
      <size>0.9204 0.27 0.0749</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.98408 -0.135396 0.115127</x>
    <y>-0.140219 -0.989507 0.03484</y>
    <z>0.109202 -0.0504283 -0.99274</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-1.23978e-007 -0.152645 1.4782e-007</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>23.1632 68.9993 9.6348</rotlimitmax>
   <rotlimitmin>-23.1632 -68.9993 -24.6682</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.931555 0.0 -0.363599</x>
    <y>-0.363599 0.0 -0.931555</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -1.80405e-007 0.573847</offset>
    <x>1.0 5.33267e-007 0.0</x>
    <y>0.0 3.20313e-007 -1.0</y>
    <z>-5.33267e-007 1.0 3.20313e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.980382 0.116992 0.158633</x>
    <y>0.0850989 -0.977159 0.194728</y>
    <z>0.177791 -0.177408 -0.967944</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>1.81198e-007 0.152645 -1.19209e-007</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>51.1545 63.6791 1.4856</rotlimitmax>
   <rotlimitmin>-51.1545 -63.6791 -36.3315</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.896455 2.09257e-007 -0.443134</x>
    <y>-0.443134 -3.05424e-007 -0.896455</y>
    <z>-3.22934e-007 1.0 -1.81069e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.573847</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.799482 0.591406 0.105204</x>
    <y>0.582005 0.719298 0.379317</y>
    <z>0.148657 0.364486 -0.919266</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.00587417 0.23889 0.772506</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 22.6199</rotlimitmax>
   <rotlimitmin>0.0 0.0 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.471001 0.00424969 -0.882122</x>
    <y>-0.882133 0.00169028 -0.470999</y>
    <z>-0.000510558 0.99999 0.00454491</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>1.7049e-007 1.75596e-007 0.432448</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.892182 -0.412953 -0.182981</x>
    <y>-0.308751 0.853267 -0.420248</y>
    <z>0.329674 -0.318442 -0.888769</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0374105 -0.395381 0.702326</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 44.9685</rotlimitmax>
   <rotlimitmin>0.0 0.0 -21.0375</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.344526 -2.47663e-007 -0.938777</x>
    <y>-0.938777 3.45442e-007 -0.344526</y>
    <z>4.09619e-007 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.432449</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -12.9946</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999699 0.0235546 0.0068638</x>
    <y>-0.0234035 0.999499 -0.021321</y>
    <z>-0.00736256 0.0211539 0.999749</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0114552 -0.0917815 0.94754</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail1" class="novodex" id="Joint_Bip01_Ponytail1" parent="#Bip01_Head">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.920674 -5.37828e-006 -0.390332</x>
    <y>-5.34863e-006 1.0 -1.16295e-006</y>
    <z>0.390332 1.01704e-006 -0.920674</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.230413 0.000662804 0.064265</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail11" class="novodex" id="Joint_Bip01_Ponytail11" parent="#Bip01_Ponytail1">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.985797 -2.8794e-006 -0.167941</x>
    <y>3.37663e-006 1.0 2.67519e-006</y>
    <z>0.167941 -3.20427e-006 0.985797</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000247185 0.0 0.307647</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail12" class="novodex" id="Joint_Bip01_Ponytail12" parent="#Bip01_Ponytail11">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999642 -0.000110469 -0.0267704</x>
    <y>0.000113534 1.0 0.000112982</y>
    <z>0.0267704 -0.000115981 0.999642</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000234272 -1.00979e-006 0.31473</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail13" class="novodex" id="Joint_Bip01_Ponytail13" parent="#Bip01_Ponytail12">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997956 0.000194817 0.0639084</x>
    <y>-0.000182644 1.0 -0.00019632</y>
    <z>-0.0639085 0.000184246 0.997956</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000232157 -3.40007e-005 0.293931</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail14" class="novodex" id="Joint_Bip01_Ponytail14" parent="#Bip01_Ponytail13">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.992074 -0.000731365 0.125656</x>
    <y>0.000652197 1.0 0.000671175</y>
    <z>-0.125656 -0.000583903 0.992074</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000209289 2.12721e-005 0.292333</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail15" class="novodex" id="Joint_Bip01_Ponytail15" parent="#Bip01_Ponytail14">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999778 0.000601976 0.0210729</x>
    <y>-0.000589152 1.0 -0.000614751</y>
    <z>-0.0210733 0.000602199 0.999778</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00020092 -0.000155433 0.264213</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail16" class="novodex" id="Joint_Bip01_Ponytail16" parent="#Bip01_Ponytail15">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997055 -0.00020937 0.0766943</x>
    <y>0.000194777 1.0 0.000197762</y>
    <z>-0.0766943 -0.000182241 0.997055</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000195878 3.30069e-006 0.252673</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Ponytail17" class="novodex" id="Joint_Bip01_Ponytail17" parent="#Bip01_Ponytail16">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.994425 0.000188658 0.105443</x>
    <y>-0.000167772 1.0 -0.000206943</y>
    <z>-0.105443 0.000188099 0.994425</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000180256 -4.49069e-005 0.245683</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>1.0 -3.03587e-006 4.76839e-007</x>
    <y>3.03587e-006 1.0 -6.99381e-007</y>
    <z>-4.76837e-007 6.99382e-007 1.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.0</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
