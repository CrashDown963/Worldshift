<?xml version="1.0"?>
<library id="CommanderPhysXOnly" type="physics">
 <scenedesc source="3dsmax">
  <eye>2.2384 -4.36597 2.44004</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>1.75473 -3.50728 2.27058</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine01">
   <mass>40.0</mass>
   <orientation>0.000397716 -1.56976e-005 -0.707107 0.707106</orientation>
   <position>0.0 0.000176239 1.44577</position>
   <shape id="shape_Bip01_Spine01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Spine01_geom">
     <capsule>
      <p0>0.0 0.0 0.391503</p0>
      <p1>0.0 0.0 0.619663</p1>
      <radius>0.391503</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.706962 0.703663 -0.00139653 -0.0711405</orientation>
   <position>-0.186753 -2.9855e-007 1.30994</position>
   <shape id="shape_Bip01_R_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.21</p0>
      <p1>0.0 0.0 0.395</p1>
      <radius>0.21</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf01">
   <mass>10.0</mass>
   <orientation>-0.700283 0.706719 0.0969496 0.027425</orientation>
   <position>-0.244715 -0.0605669 0.725327</position>
   <shape id="shape_Bip01_R_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.275</p0>
      <p1>0.0 0.0 0.495</p1>
      <radius>0.275</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.703664 0.706961 -0.0711405 -0.00139676</orientation>
   <position>0.186753 1.88033e-007 1.30994</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.21</p0>
      <p1>0.0 0.0 0.395</p1>
      <radius>0.21</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>0.70672 -0.700283 -0.0274251 -0.0969493</orientation>
   <position>0.244715 -0.0605662 0.725327</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.275</p0>
      <p1>0.0 0.0 0.495</p1>
      <radius>0.275</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.716519 0.69059 0.0829817 0.0529159</orientation>
   <position>0.597753 7.06551e-007 2.07671</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.203</p0>
      <p1>0.0 0.0 0.282</p1>
      <radius>0.203</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.718247 -0.664881 0.0663874 -0.194031</orientation>
   <position>0.685489 0.0177223 1.62861</position>
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
      <p0>0.0 0.0 0.18</p0>
      <p1>0.0 0.0 0.59</p1>
      <radius>0.18</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>10.0</mass>
   <orientation>-0.690589 -0.71652 0.0529161 0.0829818</orientation>
   <position>-0.597753 -9.06663e-007 2.07671</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.203</p0>
      <p1>0.0 0.0 0.282</p1>
      <radius>0.203</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.66488 -0.718247 0.19403 -0.066388</orientation>
   <position>-0.685489 0.0177205 1.62861</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.18</p0>
      <p1>0.0 0.0 0.59</p1>
      <radius>0.18</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>-0.0765383 -0.103431 -0.604078 0.786469</orientation>
   <position>0.00548143 -0.00325087 1.38195</position>
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
  <rigidbody id="Bone_Gun">
   <mass>7.5</mass>
   <orientation>0.0 0.0 0.0 1.0</orientation>
   <position>-0.256712 -0.692966 1.23934</position>
   <shape id="shape_Bone_Gun">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_Gun_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.3</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 -0.02</position>
    <geometry id="Bone_Gun_geom">
     <box>
      <size>1.3416 0.28 0.13</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh01" class="novodex" id="Joint_Bip01_R_Thigh01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.994672 -0.000458748 0.103088</x>
    <y>0.00977259 -0.995067 -0.098722</y>
    <z>0.102624 0.0992035 -0.989761</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.000250132 -0.186832 -0.135726</offset>
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
    <x>0.961307 -6.30301e-007 -0.27548</x>
    <y>-0.27548 1.28914e-007 -0.961307</y>
    <z>6.41426e-007 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -2.08945e-007 0.590589</offset>
    <x>1.0 5.33267e-007 0.0</x>
    <y>0.0 3.20313e-007 -1.0</y>
    <z>-5.33267e-007 1.0 3.20313e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh01" class="novodex" id="Joint_Bip01_L_Thigh01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.994672 0.000463548 0.103087</x>
    <y>-0.00964776 -0.995182 0.0975645</y>
    <z>0.102636 -0.0980393 -0.989876</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.000249228 0.186673 -0.135945</offset>
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
    <x>0.961307 2.58955e-007 -0.27548</x>
    <y>-0.27548 -1.31893e-007 -0.961307</y>
    <z>-2.85269e-007 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.590589</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.998448 0.0404673 -0.0382524</x>
    <y>0.032425 0.980971 0.191429</y>
    <z>0.0452711 0.189891 -0.980761</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000166003 0.598122 0.630587</offset>
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
    <x>0.915135 0.00424968 -0.403126</x>
    <y>-0.403136 0.00169031 -0.915139</y>
    <z>-0.00320764 0.99999 0.00326006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>1.46072e-007 1.46599e-007 0.456952</offset>
    <x>0.999991 0.00424959 0.0</x>
    <y>-7.17947e-006 0.00168943 -0.999999</y>
    <z>-0.00424958 0.99999 0.00168945</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -70.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm01" class="novodex" id="Joint_Bip01_R_UpperArm01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.998448 -0.0404724 -0.0382517</x>
    <y>-0.032377 0.980748 -0.192576</y>
    <z>0.0453093 -0.191039 -0.980536</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000163054 -0.597384 0.631286</offset>
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
    <x>0.915143 -6.67199e-007 -0.40313</x>
    <y>-0.40313 4.02514e-007 -0.915143</y>
    <z>7.72847e-007 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.456952</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine01">
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
