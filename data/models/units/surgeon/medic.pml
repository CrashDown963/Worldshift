<?xml version="1.0"?>
<library id="Medic_PhysXmax" type="physics">
 <scenedesc source="3dsmax">
  <eye>-1.016 -3.48312 2.05903</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.745899 -2.54116 1.85966</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>40.0</mass>
   <orientation>-0.00128958 0.00046941 -0.683801 0.729667</orientation>
   <position>-0.0191627 -0.112027 1.02566</position>
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
      <p0>0.0 0.0 0.21</p0>
      <p1>0.0 0.0 0.38</p1>
      <radius>0.21</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>20.0</mass>
   <orientation>-0.771998 0.635167 -0.00788763 -0.022801</orientation>
   <position>-0.116738 -0.150089 0.961708</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.35</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>10.0</mass>
   <orientation>-0.769243 0.63168 -0.065631 -0.0702639</orientation>
   <position>-0.124165 -0.170099 0.519776</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.44</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>20.0</mass>
   <orientation>-0.804648 0.592034 -0.0406699 -0.0195672</orientation>
   <position>0.0894141 -0.0803259 0.961958</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.35</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>10.0</mass>
   <orientation>-0.804281 0.591851 -0.0473697 -0.024497</orientation>
   <position>0.108121 -0.115565 0.521313</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.44</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>10.0</mass>
   <orientation>0.571417 0.458254 -0.278776 0.621104</orientation>
   <position>0.145264 -0.185039 1.50636</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>10.0</mass>
   <orientation>0.562159 0.438048 -0.297004 0.635517</orientation>
   <position>0.217823 -0.464482 1.48522</position>
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
   <orientation>-0.546838 -0.730344 0.364747 -0.185811</orientation>
   <position>-0.227568 -0.172166 1.49489</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.095</p0>
      <p1>0.0 0.0 0.165</p1>
      <radius>0.095</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>10.0</mass>
   <orientation>-0.581594 -0.745632 0.306301 -0.109363</orientation>
   <position>-0.264478 -0.385224 1.30243</position>
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
   <orientation>-0.161465 -0.206997 -0.655144 0.708426</orientation>
   <position>-0.0241677 -0.0850284 1.64287</position>
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
      <radius>0.13</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>10.0</mass>
   <orientation>0.00390399 -0.0297938 -0.712337 0.701194</orientation>
   <position>-0.016982 -0.11656 0.905275</position>
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
   <mass>4.0</mass>
   <orientation>0.0 -1.50996e-007 0.0 1.0</orientation>
   <position>-0.200845 -0.707929 1.70878</position>
   <shape id="shape_Bone_Gun">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_Gun_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.3</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.08</position>
    <geometry id="Bone_Gun_geom">
     <box>
      <size>0.19 0.09 0.33</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.990829 0.128106 0.0429638</x>
    <y>0.128937 -0.991504 -0.017162</y>
    <z>0.0404002 0.0225442 -0.998929</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0315871 -0.0996756 -0.0642392</offset>
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
    <x>0.988802 0.0 0.149232</x>
    <y>0.149232 0.0 -0.988802</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -1.69207e-007 0.442447</offset>
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
    <x>0.968431 0.235707 0.0811447</x>
    <y>0.233173 -0.971631 0.0395422</y>
    <z>0.0881631 -0.0193732 -0.995918</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0246639 0.110564 -0.0633979</offset>
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
    <x>0.999861 0.0 0.0166556</x>
    <y>0.0166556 0.0 -0.999861</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.442448</offset>
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
    <x>-0.150468 -0.134235 0.979459</x>
    <y>0.437423 0.879443 0.187727</y>
    <z>-0.886578 0.456684 -0.0736102</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0840365 0.158134 0.481009</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>62.0812 31.1647 22.6199</rotlimitmax>
   <rotlimitmin>-62.0812 -31.1647 -15.9454</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.997924 0.00424977 -0.0642679</x>
    <y>-0.0642756 0.00168976 -0.997931</y>
    <z>-0.00413237 0.99999 0.0019594</z>
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
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.68412 -0.075353 0.725466</x>
    <y>-0.287498 0.941978 -0.173271</y>
    <z>-0.670317 -0.327108 -0.66609</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0470069 -0.213049 0.468646</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>67.9139 16.4223 44.9685</rotlimitmax>
   <rotlimitmin>-67.9139 -16.4223 -29.9722</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.978653 0.0 0.205517</x>
    <y>0.205517 0.0 -0.978653</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.289483</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.863751 -0.0246841 -0.503314</x>
    <y>-0.00135772 0.998682 -0.0513086</y>
    <z>0.503917 0.0450013 0.862579</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0266005 -0.00480195 0.617231</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.2734 44.9509 60.1279</rotlimitmax>
   <rotlimitmin>-13.2734 -44.9509 -58.2167</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.996064 0.0796503 -0.0388866</x>
    <y>-0.0814585 0.995551 -0.0473672</y>
    <z>0.0349408 0.0503484 0.99812</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.00453543 0.00218606 -0.120386</offset>
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
