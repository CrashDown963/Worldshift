<?xml version="1.0"?>
<library id="Judge_PhysX01" type="physics">
 <scenedesc source="3dsmax">
  <eye>-0.847672 -4.49913 0.604213</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.640401 -3.52401 0.682715</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine02">
   <mass>40.0</mass>
   <orientation>0.015727 0.015727 -0.706932 0.706932</orientation>
   <position>0.00492395 -0.0083746 1.13003</position>
   <shape id="shape_Bip01_Spine02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine02_geom">
     <capsule>
      <p0>0.0 0.0 0.2247</p0>
      <p1>0.0 0.0 0.4066</p1>
      <radius>0.2247</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.645483 0.759715 0.0124272 -0.0776497</orientation>
   <position>-0.0947517 0.0363801 1.17758</position>
   <shape id="shape_Bip01_R_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.15</p0>
      <p1>0.0 0.0 0.45</p1>
      <radius>0.15</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf01">
   <mass>10.0</mass>
   <orientation>0.644471 -0.762211 -0.0382099 0.0472303</orientation>
   <position>-0.154051 0.000382068 0.596582</position>
   <shape id="shape_Bip01_R_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.18</p0>
      <p1>0.0 0.0 0.47</p1>
      <radius>0.18</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.790401 0.606549 -0.0826149 0.0232102</orientation>
   <position>0.115488 0.0492986 1.16928</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.15</p0>
      <p1>0.0 0.0 0.45</p1>
      <radius>0.15</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>-0.794059 0.607307 -0.0248343 0.0055703</orientation>
   <position>0.205764 0.0211902 0.610367</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.18</p0>
      <p1>0.0 0.0 0.47</p1>
      <radius>0.18</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.616954 0.628706 0.396295 0.258934</orientation>
   <position>0.225858 -0.0197388 1.66772</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.704571 -0.603788 -0.233502 -0.290684</orientation>
   <position>0.461665 0.0320221 1.50798</position>
   <shape id="shape_Bip01_L_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_L_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.10695</p0>
      <p1>0.0 0.0 0.42617</p1>
      <radius>0.10695</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>10.0</mass>
   <orientation>-0.511922 -0.718746 0.354506 0.309299</orientation>
   <position>-0.208125 0.0988235 1.59612</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.485469 -0.738886 0.389947 0.257504</orientation>
   <position>-0.416061 0.0429747 1.46543</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.10695</p0>
      <p1>0.0 0.0 0.42617</p1>
      <radius>0.10695</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>-0.0594159 -0.0899042 -0.606177 0.787995</orientation>
   <position>0.0103681 -0.00899464 1.06612</position>
   <shape id="shape_Bip01_Pelvis01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis01_geom">
     <sphere>
      <radius>0.0295858</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh01" class="novodex" id="Joint_Bip01_R_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.977191 -0.171526 0.125202</x>
    <y>-0.154643 -0.978837 -0.134026</y>
    <z>0.145542 0.111608 -0.983037</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0468252 -0.0996756 0.0455163</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>23.1632 68.9993 9.6348</rotlimitmax>
   <rotlimitmin>-23.1632 -68.9993 -24.6682</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf01" class="novodex" id="Joint_Bip01_R_Calf01" parent="#Bip01_R_Thigh01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.996807 0.0 -0.0798539</x>
    <y>-0.0798539 0.0 -0.996807</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.014682 -0.0171573 0.584692</offset>
    <x>1.0 5.33267e-007 0.0</x>
    <y>0.0 3.20313e-007 -1.0</y>
    <z>-5.33267e-007 1.0 3.20313e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh01" class="novodex" id="Joint_Bip01_L_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.957161 0.268947 0.107283</x>
    <y>0.250546 -0.955 0.158754</y>
    <z>0.145152 -0.125074 -0.981472</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0593617 0.110564 0.0366458</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>51.1545 63.6791 1.4856</rotlimitmax>
   <rotlimitmin>-51.1545 -63.6791 -36.3315</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf01" class="novodex" id="Joint_Bip01_L_Calf01" parent="#Bip01_L_Thigh01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997508 0.00692934 -0.0702102</x>
    <y>-0.0705514 0.0979715 -0.992685</y>
    <z>0.0 0.995165 0.0982162</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00757841 -0.00229657 0.566798</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.98729 0.0389212 -0.154088</x>
    <y>-0.104641 0.570536 0.814579</y>
    <z>0.119617 0.82035 -0.559212</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0125589 0.220934 0.537661</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>62.0812 31.1647 22.6199</rotlimitmax>
   <rotlimitmin>-62.0812 -31.1647 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm01" class="novodex" id="Joint_Bip01_L_Forearm01" parent="#Bip01_L_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.947286 -0.0575971 -0.315168</x>
    <y>-0.320369 -0.180985 -0.929844</y>
    <z>-0.0034844 0.981798 -0.189897</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.289483</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm01" class="novodex" id="Joint_Bip01_R_UpperArm01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.957867 -0.187554 0.21752</x>
    <y>-0.28454 0.516587 -0.807574</y>
    <z>0.0390957 -0.835441 -0.548188</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.12782 -0.213049 0.460864</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>67.9139 16.4223 44.9685</rotlimitmax>
   <rotlimitmin>-67.9139 -16.4223 -29.9722</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm01" class="novodex" id="Joint_Bip01_R_Forearm01" parent="#Bip01_R_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.989925 0.0 -0.141596</x>
    <y>-0.141596 0.0 -0.989925</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00485099 -0.0119709 0.251534</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.934207 -0.258466 -0.245873</x>
    <y>0.248933 0.966013 -0.0696551</y>
    <z>0.25552 0.00386637 0.966796</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.00346158 0.00544413 -0.0638186</offset>
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
