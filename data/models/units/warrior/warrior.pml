<?xml version="1.0"?>
<library id="WARRIOR_NEW_shootvars_LOD" type="physics">
 <scenedesc source="3dsmax">
  <eye>-1.13583 -3.34482 1.96952</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-0.831595 -2.43555 1.6855</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine02">
   <mass>40.0</mass>
   <orientation>0.0260701 0.0260722 -0.706625 0.706627</orientation>
   <position>1.24346 -0.0526762 1.24879</position>
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
      <p0>0.0 0.0 0.1785</p0>
      <p1>0.0 0.0 0.4115</p1>
      <radius>0.1785</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.797804 0.579607 0.108606 0.125572</orientation>
   <position>1.11519 -0.0385084 1.12666</position>
   <shape id="shape_Bip01_R_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.105</p0>
      <p1>0.0 0.0 0.425</p1>
      <radius>0.105</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf01">
   <mass>10.0</mass>
   <orientation>-0.804618 0.592549 -0.0296094 0.0244685</orientation>
   <position>1.10043 0.135102 0.623873</position>
   <shape id="shape_Bip01_R_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.083</p0>
      <p1>0.0 0.0 0.517</p1>
      <radius>0.083</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.677551 0.716198 0.155083 0.0627188</orientation>
   <position>1.37173 -0.0385081 1.12666</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.105</p0>
      <p1>0.0 0.0 0.425</p1>
      <radius>0.105</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>0.683362 -0.718173 -0.127056 -0.0331791</orientation>
   <position>1.30771 0.124922 0.624321</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.083</p0>
      <p1>0.0 0.0 0.517</p1>
      <radius>0.083</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.382109 0.813124 -0.438346 -0.0259962</orientation>
   <position>1.47299 -0.0384318 1.69866</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.086</p0>
      <p1>0.0 0.0 0.254</p1>
      <radius>0.086</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.298061 -0.804785 0.499313 -0.119026</orientation>
   <position>1.34153 -0.279906 1.48458</position>
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
      <p0>0.0 0.0 0.063</p0>
      <p1>0.0 0.0 0.457</p1>
      <radius>0.063</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>10.0</mass>
   <orientation>-0.495532 -0.719231 -0.0461522 -0.484794</orientation>
   <position>1.01393 -0.0384323 1.69866</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.086</p0>
      <p1>0.0 0.0 0.254</p1>
      <radius>0.086</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.497231 -0.647346 0.0210414 -0.577288</orientation>
   <position>1.27286 -0.182717 1.51548</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.063</p0>
      <p1>0.0 0.0 0.457</p1>
      <radius>0.063</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head01">
   <mass>20.0</mass>
   <orientation>0.00651382 0.00651379 -0.707077 0.707076</orientation>
   <position>1.24346 -0.0827144 1.82748</position>
   <shape id="shape_Bip01_Head01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Head01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <position>0.0 1.33514e-007 0.0669579</position>
    <geometry id="Bip01_Head01_geom">
     <sphere>
      <radius>0.1222</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>0.732694 0.00251187 -0.00233227 0.680549</orientation>
   <position>1.24346 -0.0363423 1.12666</position>
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
  <rigidbody id="Bone_Rifle01">
   <mass>10.0</mass>
   <orientation>-0.681009 0.667146 -0.218019 -0.208831</orientation>
   <position>-0.217524 -0.296373 1.41908</position>
   <shape id="shape_Bone_Rifle01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bone_Rifle01_mat">
     <dynamicfriction>0.35</dynamicfriction>
     <restitution>0.33</restitution>
     <staticfriction>0.35</staticfriction>
    </physicsmaterial>
    <position>0.0 0.0 0.025</position>
    <geometry id="Bone_Rifle01_geom">
     <box>
      <size>0.56 0.15 0.05</size>
     </box>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_R_Thigh01" class="novodex" id="Joint_Bip01_R_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.918608 0.301253 -0.255746</x>
    <y>0.304519 -0.952103 -0.0277245</y>
    <z>-0.251848 -0.0524115 -0.966346</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00512998 -0.128272 -0.122839</offset>
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
    <x>0.941358 0.0 0.33741</x>
    <y>0.33741 0.0 -0.941358</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.532121</offset>
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
    <x>0.970589 -0.0437636 -0.23673</x>
    <y>-0.0739821 -0.989976 -0.120311</y>
    <z>-0.229091 0.134287 -0.964098</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00512985 0.128272 -0.122838</offset>
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
    <x>0.99661 0.0 0.0822721</x>
    <y>0.0822721 0.0 -0.99661</y>
    <z>0.0 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.532121</offset>
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
    <x>-0.620874 -0.268815 0.736379</x>
    <y>-0.706632 0.598616 -0.377268</y>
    <z>-0.339393 -0.754585 -0.561618</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0473563 0.229528 0.447597</offset>
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
    <x>0.936736 0.00424982 -0.350011</x>
    <y>-0.350021 0.00169022 -0.936741</y>
    <z>-0.00338938 0.99999 0.00307081</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.348452</offset>
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
    <x>-0.707475 -0.543561 0.451687</x>
    <y>-0.0388433 0.668054 0.743098</y>
    <z>-0.70567 0.508178 -0.493745</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0473565 -0.229531 0.447596</offset>
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
    <x>0.963685 5.08671e-007 -0.267041</x>
    <y>-0.267041 4.083e-007 -0.963685</y>
    <z>-3.81166e-007 1.0 5.29309e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.348452</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head01" class="novodex" id="Joint_Bip01_Head01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.99847 3.14621e-006 -0.0553047</x>
    <y>-3.32068e-006 1.0 -3.06282e-006</y>
    <z>0.0553047 3.24178e-006 0.99847</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0126879 -1.73506e-006 0.579338</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>13.2734 44.9509 60.1279</rotlimitmax>
   <rotlimitmin>-13.2734 -44.9509 -58.2167</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>4.93465e-007 3.85644e-006 1.0</x>
    <y>0.999977 0.00685217 -5.19878e-007</y>
    <z>-0.00685217 0.999977 -3.87199e-006</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.00729003 3.95559e-007 -0.122998</offset>
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
