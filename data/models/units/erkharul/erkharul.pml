<?xml version="1.0"?>
<library id="FinalBoss_PhysX" type="physics">
 <scenedesc source="3dsmax">
  <eye>-8.98308 -24.411 9.27733</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>-8.57239 -23.5099 9.13809</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine01">
   <mass>40.0</mass>
   <orientation>0.0701433 0.0656755 -0.726049 0.680896</orientation>
   <position>-0.000794334 0.000988121 5.92313</position>
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
      <p0>0.0 0.0 1.4175</p0>
      <p1>0.0 0.0 2.46659</p1>
      <radius>1.4175</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.592644 0.770096 -0.0200974 -0.235205</orientation>
   <position>-0.891694 0.0933628 5.00786</position>
   <shape id="shape_Bip01_R_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.79</p0>
      <p1>0.0 0.0 1.55</p1>
      <radius>0.79</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Calf01">
   <mass>10.0</mass>
   <orientation>0.542078 -0.795578 -0.24038 -0.124198</orientation>
   <position>-1.68946 -0.636751 2.91339</position>
   <shape id="shape_Bip01_R_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.82</p0>
      <p1>0.0 0.0 2.31</p1>
      <radius>0.82</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.778516 0.548442 -0.284565 -0.110216</orientation>
   <position>0.889899 -0.0933633 5.00786</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.79</p0>
      <p1>0.0 0.0 1.55</p1>
      <radius>0.79</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>-0.823486 0.539674 0.0945229 0.147269</orientation>
   <position>1.64934 -1.23364 3.0897</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.82</p0>
      <p1>0.0 0.0 2.31</p1>
      <radius>0.82</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.609219 0.661677 0.383945 0.208861</orientation>
   <position>1.62836 0.0672492 7.67943</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.64</p0>
      <p1>0.0 0.0 0.96</p1>
      <radius>0.64</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.718816 -0.415857 0.043192 -0.55543</orientation>
   <position>2.68981 0.42897 6.79809</position>
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
      <p0>0.0 0.0 0.75</p0>
      <p1>0.0 0.0 2.28</p1>
      <radius>0.75</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_UpperArm01">
   <mass>10.0</mass>
   <orientation>-0.592074 -0.692156 0.209653 0.355548</orientation>
   <position>-1.60904 0.274439 7.68068</position>
   <shape id="shape_Bip01_R_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.64</p0>
      <p1>0.0 0.0 0.96</p1>
      <radius>0.64</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_R_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.414472 -0.77787 0.471687 -0.0253398</orientation>
   <position>-2.68377 0.464282 6.72379</position>
   <shape id="shape_Bip01_R_Forearm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_R_Forearm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_R_Forearm01_geom">
     <capsule>
      <p0>0.0 0.0 0.75</p0>
      <p1>0.0 0.0 2.28</p1>
      <radius>0.75</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Head01">
   <mass>20.0</mass>
   <orientation>0.125491 0.115523 -0.695478 0.698009</orientation>
   <position>-0.0542015 -0.831491 7.99429</position>
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
      <radius>0.13</radius>
     </sphere>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>1.17469e-006 0.0 -0.743046 0.66924</orientation>
   <position>-0.000897801 0.0 5.00786</position>
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
  <joint child="#Bip01_R_Thigh01" class="novodex" id="Joint_Bip01_R_Thigh01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.822732 -0.28004 0.494661</x>
    <y>-0.128525 -0.939334 -0.318015</y>
    <z>0.553709 0.198065 -0.808812</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.140657 -0.89513 -0.904939</offset>
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
    <x>0.619594 -2.58104e-007 -0.784922</x>
    <y>-0.784922 3.30793e-007 -0.619594</y>
    <z>4.19567e-007 1.0 0.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-2.81906e-007 -1.70783e-007 2.35719</offset>
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
    <x>0.652244 0.451022 0.609226</x>
    <y>0.286813 -0.890808 0.352418</y>
    <z>0.701652 -0.055129 -0.710384</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.211459 0.89477 -0.89142</offset>
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
    <x>0.598284 -1.63666e-007 -0.801284</x>
    <y>-0.801284 -2.59231e-007 -0.598284</y>
    <z>0.0 1.0 -2.86237e-007</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-6.60175e-007 0.0 2.35719</offset>
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
    <x>-0.972684 -0.150148 -0.177037</x>
    <y>-0.23207 0.646997 0.726318</y>
    <z>0.00548665 0.747563 -0.664168</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.503374 1.62182 1.69098</offset>
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
    <x>0.320319 0.00424959 -0.9473</x>
    <y>-0.94731 0.00168999 -0.320314</y>
    <z>0.000239726 0.99999 0.00456701</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>8.28013e-007 0.0 1.42629</offset>
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
    <x>-0.992617 -0.112801 0.0445842</x>
    <y>-0.108063 0.655511 -0.747414</y>
    <z>0.0550835 -0.746714 -0.662861</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.50286 -1.62221 1.69286</offset>
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
    <x>0.526659 0.000145717 -0.850077</x>
    <y>-0.850074 -0.00244126 -0.526658</y>
    <z>-0.002152 0.999997 -0.00116184</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 1.45145</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 2.9342e-007 -1.0</y>
    <z>0.0 1.0 2.9342e-007</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 -110.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Head01" class="novodex" id="Joint_Bip01_Head01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.986478 -0.06679 0.149669</x>
    <y>0.0662747 0.997766 0.00843322</y>
    <z>-0.149898 0.00160006 0.9887</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.422592 0.000410711 2.19248</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.980738 0.0395218 -0.19129</x>
    <y>-0.0402359 0.99919 0.000151637</y>
    <z>0.191141 0.00754799 0.981534</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.176058 -0.00018028 -0.89818</offset>
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
