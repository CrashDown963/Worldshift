<?xml version="1.0"?>
<library id="Brut_PhysX3" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.162864 -3.27994 1.31877</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.145417 -2.28044 1.34495</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine">
   <mass>80.0</mass>
   <orientation>0.0435984 0.0436009 -0.70576 0.705762</orientation>
   <position>0.0 0.00761467 1.0621</position>
   <shape id="shape_Bip01_Spine">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Spine_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Spine_geom">
     <capsule>
      <p0>0.0 0.0 0.306862</p0>
      <p1>0.0 0.0 0.410568</p1>
      <radius>0.306862</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh">
   <mass>30.0</mass>
   <orientation>0.726115 -0.671804 0.0407002 0.140641</orientation>
   <position>-0.282255 0.10118 0.976945</position>
   <shape id="shape_Bip01_R_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.17</p0>
      <p1>0.0 0.0 0.31</p1>
      <radius>0.17</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf">
   <mass>30.0</mass>
   <orientation>-0.696619 0.679564 0.208858 0.0963997</orientation>
   <position>-0.343707 -0.0213499 0.524013</position>
   <shape id="shape_Bip01_R_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.19</p0>
      <p1>0.0 0.0 0.37</p1>
      <radius>0.19</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh">
   <mass>30.0</mass>
   <orientation>0.671802 -0.726118 0.140635 0.0407064</orientation>
   <position>0.282254 0.101178 0.976941</position>
   <shape id="shape_Bip01_L_Thigh">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh_geom">
     <capsule>
      <p0>0.0 0.0 0.17</p0>
      <p1>0.0 0.0 0.31</p1>
      <radius>0.17</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf">
   <mass>30.0</mass>
   <orientation>0.67956 -0.696623 -0.096404 -0.208853</orientation>
   <position>0.343699 -0.0213527 0.524008</position>
   <shape id="shape_Bip01_L_Calf">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf_geom">
     <capsule>
      <p0>0.0 0.0 0.19</p0>
      <p1>0.0 0.0 0.37</p1>
      <radius>0.19</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm">
   <mass>15.0</mass>
   <orientation>-0.46683 -0.51014 -0.573253 -0.439555</orientation>
   <position>0.390582 -0.0073365 1.63337</position>
   <shape id="shape_Bip01_L_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.14</p0>
      <p1>0.0 0.0 0.23</p1>
      <radius>0.14</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm">
   <mass>15.0</mass>
   <orientation>-0.545853 -0.44016 -0.498592 -0.509617</orientation>
   <position>0.752345 0.0568316 1.64942</position>
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
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.32</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm">
   <mass>15.0</mass>
   <orientation>0.48115 0.502808 -0.471124 -0.541961</orientation>
   <position>-0.390576 -0.00733435 1.63337</position>
   <shape id="shape_Bip01_R_UpperArm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm_geom">
     <capsule>
      <p0>0.0 0.0 0.14</p0>
      <p1>0.0 0.0 0.23</p1>
      <radius>0.14</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm">
   <mass>15.0</mass>
   <orientation>-0.481149 -0.502807 0.471125 0.541961</orientation>
   <position>-0.757733 0.0102313 1.6449</position>
   <shape id="shape_Bip01_R_Forearm">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.32</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head">
   <mass>10.0</mass>
   <orientation>-0.0704511 -0.0702231 0.704831 -0.702366</orientation>
   <position>-0.000596487 -0.0212989 1.79958</position>
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
      <radius>0.14</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis">
   <mass>20.0</mass>
   <orientation>0.105021 0.104916 -0.699234 0.69931</orientation>
   <position>0.0 0.101179 0.976943</position>
   <shape id="shape_Bip01_Pelvis">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Pelvis_mat">
     <dynamicfriction>0.9</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.9</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bip01_Pelvis_geom">
     <sphere>
      <radius>0.218994</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>15.0</mass>
   <orientation>-0.740344 -0.597863 -0.235756 -0.197157</orientation>
   <position>0.440033 0.026533 1.30786</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>0.8</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>0.8</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.14</p0>
      <p1>0.0 0.0 0.23</p1>
      <radius>0.14</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>15.0</mass>
   <orientation>-0.766735 -0.443379 0.125729 -0.446907</orientation>
   <position>0.655109 0.0228453 1.00957</position>
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
      <p0>0.0 0.0 0.11</p0>
      <p1>0.0 0.0 0.33</p1>
      <radius>0.11</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>15.0</mass>
   <orientation>-0.238243 -0.90086 0.224507 0.285109</orientation>
   <position>-0.42444 0.0192462 1.31442</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.14</p0>
      <p1>0.0 0.0 0.23</p1>
      <radius>0.14</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>15.0</mass>
   <orientation>-0.270134 -0.897427 0.348689 -0.0083135</orientation>
   <position>-0.652694 -0.0795518 1.04352</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.11</p0>
      <p1>0.0 0.0 0.33</p1>
      <radius>0.11</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bone_Gun">
   <mass>20.0</mass>
   <orientation>0.451965 -0.131197 0.151189 0.869285</orientation>
   <position>-0.0682168 -0.61238 1.25642</position>
   <shape id="shape_Bone_Gun">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_Gun_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.35</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.0</position>
    <geometry id="Bone_Gun_geom">
     <box>
      <size>0.799948 0.648498 0.507343</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh" class="novodex" id="Joint_Bip01_R_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.926301 0.0389497 0.374766</x>
    <y>0.0940426 -0.987063 -0.129857</y>
    <z>0.364859 0.155531 -0.91798</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.082373 -0.282254 -0.0960272</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>18.5967 63.907 15.6645</rotlimitmax>
   <rotlimitmin>-18.5967 -63.907 -32.0054</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Calf" class="novodex" id="Joint_Bip01_R_Calf" parent="#Bip01_R_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.768333 0.0 -0.640051</x>
    <y>-0.640051 0.0 -0.768333</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -2.12318e-007 0.47322</offset>
    <x>1.0 5.06797e-007 0.0</x>
    <y>0.0 1.96787e-007 -1.0</y>
    <z>-5.06797e-007 1.0 1.96787e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -85.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh" class="novodex" id="Joint_Bip01_L_Thigh" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.9263 -0.038964 0.374768</x>
    <y>-0.0940537 -0.987063 0.129846</y>
    <z>0.36486 -0.155524 -0.917981</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0823689 0.282255 -0.0960288</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>28.0725 63.907 9.72309</rotlimitmax>
   <rotlimitmin>-28.0725 -63.907 -14.0362</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf" class="novodex" id="Joint_Bip01_L_Calf" parent="#Bip01_L_Thigh">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.768332 0.0 -0.640051</x>
    <y>-0.640051 0.0 -0.768332</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.47322</offset>
    <x>1.0 1.25031e-007 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>-1.25031e-007 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.019783</rotlimitmax>
   <rotlimitmin>0.0 0.0 -84.9802</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm" class="novodex" id="Joint_Bip01_L_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.984069 -3.15553e-007 -0.177788</x>
    <y>0.177789 -2.7002e-006 -0.984069</y>
    <z>0.0 -1.0 2.72956e-006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0554749 0.39058 0.568761</offset>
    <x>0.999546 0.0 0.0301228</x>
    <y>0.00083326 -0.999617 -0.0276495</y>
    <z>0.0301112 0.0276621 -0.999164</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 92.2359</rotlimitmax>
   <rotlimitmin>0.0 0.0 -19.9477</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm" class="novodex" id="Joint_Bip01_L_Forearm" parent="#Bip01_L_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.956984 0.0 -0.29014</x>
    <y>-0.29014 0.0 -0.956984</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>1.40093e-007 1.19433e-007 0.36776</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 -8.29026e-007 -1.0</y>
    <z>0.0 1.0 -8.29026e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 10.0198</rotlimitmax>
   <rotlimitmin>0.0 0.0 -104.98</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm" class="novodex" id="Joint_Bip01_R_UpperArm" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.998725 -9.82143e-007 0.0504735</x>
    <y>-0.0504735 2.23817e-006 0.998725</y>
    <z>-1.16862e-006 -1.0 2.18196e-006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0554794 -0.390578 0.568762</offset>
    <x>-0.999545 0.0 -0.0301487</x>
    <y>-0.000808115 -0.99964 0.0267921</y>
    <z>-0.0301378 0.0268043 0.999186</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 85.6486</rotlimitmax>
   <rotlimitmin>0.0 0.0 -34.9261</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm" class="novodex" id="Joint_Bip01_R_Forearm" parent="#Bip01_R_UpperArm">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>1.0 0.0 -1.74846e-007</x>
    <y>-1.74846e-007 -1.60536e-006 -1.0</y>
    <z>0.0 1.0 -1.60536e-006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>2.17438e-006 -2.05659e-006 0.367758</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>0.0 1.0 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -120.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head" class="novodex" id="Joint_Bip01_Head" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.999994 -0.00343789 9.68396e-007</x>
    <y>0.00343789 -0.999995 1.11692e-006</y>
    <z>9.58137e-007 1.12022e-006 1.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0620775 -0.000599175 0.735426</offset>
    <x>-0.997123 0.0 0.0758036</x>
    <y>-5.08168e-005 -1.0 -0.000668446</y>
    <z>0.0758036 -0.000670375 0.997123</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 40.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -40.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis" class="novodex" id="Joint_Bip01_Pelvis" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.984796 -0.000100978 0.173716</x>
    <y>0.000126319 1.0 -0.00013482</y>
    <z>-0.173716 0.000154713 0.984796</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.082371 4.58681e-007 -0.0960281</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999951 -2.75127e-006 -0.00986463</x>
    <y>0.00986463 3.24414e-006 0.999951</y>
    <z>-2.91157e-006 -1.0 3.27302e-006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0490228 0.440032 0.241566</offset>
    <x>-0.985756 0.168181 0.0</x>
    <y>0.100067 0.586519 -0.80373</y>
    <z>-0.135172 -0.792282 -0.594994</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 90.7863</rotlimitmax>
   <rotlimitmin>0.0 0.0 -20.0485</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm01" class="novodex" id="Joint_Bip01_L_Forearm01" parent="#Bip01_L_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.58846 0.0 -0.808527</x>
    <y>-0.808527 0.0 -0.58846</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 -2.95495e-007 0.36776</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 -9.14736e-007 -1.0</y>
    <z>0.0 1.0 -9.14736e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 10.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -105.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_UpperArm01" class="novodex" id="Joint_Bip01_R_UpperArm01" parent="#Bip01_Spine">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.595709 0.726701 -0.342106</x>
    <y>0.712771 -0.28195 0.642232</y>
    <z>0.370254 -0.626427 -0.685931</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0426002 -0.424441 0.248966</offset>
    <x>-0.999767 0.0 -0.0216078</x>
    <y>0.000669822 -0.99952 -0.0309919</y>
    <z>-0.0215974 -0.0309991 0.999286</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 109.613</rotlimitmax>
   <rotlimitmin>0.0 0.0 -35.4831</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_R_Forearm01" class="novodex" id="Joint_Bip01_R_Forearm01" parent="#Bip01_R_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.834468 0.00722423 -0.551009</x>
    <y>-0.551056 0.0109399 -0.834396</y>
    <z>1.37258e-007 0.999914 0.01311</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-1.55345e-007 4.36059e-007 0.36776</offset>
    <x>0.961604 0.27444 0.0</x>
    <y>0.0 0.0 -1.0</y>
    <z>-0.27444 0.961604 0.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0559529</rotlimitmax>
   <rotlimitmin>0.0 0.0 -119.944</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
