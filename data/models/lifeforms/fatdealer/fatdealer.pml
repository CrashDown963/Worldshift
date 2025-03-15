<?xml version="1.0"?>
<library id="FatDealer_PhysX_Refine" type="physics">
 <scenedesc source="3dsmax">
  <eye>0.418407 -2.91961 0.681772</eye>
  <gravity>0.0 0.0 -10.0</gravity>
  <lookat>0.313897 -1.92524 0.699213</lookat>
  <up>0.0 0.0 1.0</up>
 </scenedesc>
 <physicsmodel id="main">
  <rigidbody id="Bip01_Spine02">
   <mass>40.0</mass>
   <orientation>0.0625877 0.0625983 -0.704328 0.704334</orientation>
   <position>0.000236573 0.030467 0.888531</position>
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
      <p0>0.0 0.0 0.256956</p0>
      <p1>0.0 0.0 0.333044</p1>
      <radius>0.256956</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh02">
   <mass>20.0</mass>
   <orientation>0.071231 -0.10142 -0.715175 -0.687869</orientation>
   <position>-0.183343 0.0488727 0.784345</position>
   <shape id="shape_Bip01_L_Thigh02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh02_geom">
     <convex facecount="0">
      <vertices count="18">
         0.0 0.0 -0.300281,
         0.091924 0.0 -0.262205,
         0.0 -0.0919238 -0.262205,
         -0.0919238 0.0 -0.262205,
         1.49543e-007 0.0919239 -0.262205,
         0.13 0.0 -0.2108,
         0.0 -0.13 -0.2108,
         -0.13 0.0 -0.2108,
         1.36425e-007 0.13 -0.2108,
         0.13 0.0 -0.13,
         0.0 -0.13 -0.13,
         -0.13 0.0 -0.13,
         0.0 0.13 -0.13,
         0.0919239 0.0 -0.0380761,
         0.0 -0.0919238 -0.0380761,
         -0.0919239 0.0 -0.038076,
         0.0 0.0919239 -0.0380761,
         0.0 0.0 0.0,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf02">
   <mass>10.0</mass>
   <orientation>0.0766131 -0.112725 0.734166 0.665149</orientation>
   <position>-0.201624 -0.0457902 0.467199</position>
   <shape id="shape_Bip01_L_Calf02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf02_geom">
     <convex facecount="0">
      <vertices count="22">
         -5.61682e-007 0.0 -0.476,
         0.0848523 0.0 -0.440853,
         0.0262204 -0.0806998 -0.440853,
         -0.0686479 -0.0498752 -0.440853,
         -0.0686478 0.0498753 -0.440853,
         0.0262205 0.0806999 -0.440853,
         0.12 0.0 -0.356,
         0.0370816 -0.114127 -0.356,
         -0.0970824 -0.0705342 -0.356,
         -0.0970824 0.0705343 -0.356,
         0.0370816 0.114127 -0.356,
         0.12 0.0 -0.12,
         0.0370819 -0.114127 -0.12,
         -0.0970821 -0.0705342 -0.12,
         -0.0970821 0.0705343 -0.12,
         0.0370819 0.114127 -0.12,
         0.0848527 0.0 -0.0351471,
         0.0262209 -0.0806998 -0.0351472,
         -0.0686474 -0.0498752 -0.0351473,
         -0.0686474 0.0498753 -0.0351473,
         0.0262209 0.0806999 -0.0351471,
         0.0 0.0 0.0,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Thigh01">
   <mass>20.0</mass>
   <orientation>-0.700058 0.703267 -0.101879 -0.0703878</orientation>
   <position>0.181117 0.0488706 0.784345</position>
   <shape id="shape_Bip01_L_Thigh01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Thigh01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Thigh01_geom">
     <capsule>
      <p0>0.0 0.0 0.13</p0>
      <p1>0.0 0.0 0.163088</p1>
      <radius>0.13</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Calf01">
   <mass>10.0</mass>
   <orientation>0.677428 -0.722832 -0.11473 -0.0737714</orientation>
   <position>0.201871 -0.045183 0.467169</position>
   <shape id="shape_Bip01_L_Calf01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Calf01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Calf01_geom">
     <capsule>
      <p0>0.0 0.0 0.12</p0>
      <p1>0.0 0.0 0.3448</p1>
      <radius>0.12</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm01">
   <mass>10.0</mass>
   <orientation>0.868704 0.409574 0.276321 -0.0353457</orientation>
   <position>0.217837 -0.0174876 1.41265</position>
   <shape id="shape_Bip01_L_UpperArm01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm01_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm01_geom">
     <capsule>
      <p0>0.0 0.0 0.1026</p0>
      <p1>0.0 0.0 0.2484</p1>
      <radius>0.1026</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm01">
   <mass>10.0</mass>
   <orientation>-0.88327 -0.398272 -0.0166395 -0.246856</orientation>
   <position>0.369198 0.0790597 1.12921</position>
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
      <p0>0.0 0.0 0.1</p0>
      <p1>0.0 0.0 0.38</p1>
      <radius>0.1</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_UpperArm02">
   <mass>10.0</mass>
   <orientation>-0.084251 0.481135 -0.487305 0.72384</orientation>
   <position>-0.217757 -0.0174851 1.41265</position>
   <shape id="shape_Bip01_L_UpperArm02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_UpperArm02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_UpperArm02_geom">
     <convex facecount="0">
      <vertices count="18">
         2.09946e-007 0.0 -0.3718,
         0.0943141 0.0 -0.332734,
         1.88523e-007 -0.094314 -0.332734,
         -0.0943137 0.0 -0.332734,
         1.95495e-007 0.0943138 -0.332734,
         0.13338 0.0 -0.23842,
         1.3553e-007 -0.13338 -0.23842,
         -0.13338 0.0 -0.23842,
         1.4539e-007 0.13338 -0.23842,
         0.13338 0.0 -0.13338,
         0.0 -0.13338 -0.13338,
         -0.13338 0.0 -0.13338,
         0.0 0.13338 -0.13338,
         0.0943139 0.0 -0.0390661,
         0.0 -0.094314 -0.039066,
         -0.0943139 0.0 -0.039066,
         0.0 0.0943138 -0.0390661,
         0.0 0.0 0.0,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_L_Forearm02">
   <mass>10.0</mass>
   <orientation>-0.0903791 0.0657583 -0.678456 0.726089</orientation>
   <position>-0.479003 0.098922 1.23723</position>
   <shape id="shape_Bip01_L_Forearm02">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_L_Forearm02_mat">
     <dynamicfriction>1.0</dynamicfriction>
     <restitution>0.1</restitution>
     <staticfriction>1.0</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_L_Forearm02_geom">
     <convex facecount="0">
      <vertices count="22">
         1.44467e-007 -2.08056e-007 -1.032,
         0.126919 -2.1063e-007 -0.979428,
         0.0392201 -0.120707 -0.979428,
         -0.102679 -0.074601 -0.979428,
         -0.102679 0.0746007 -0.979428,
         0.0392201 0.120707 -0.979428,
         0.17949 -1.95821e-007 -0.85251,
         0.0554656 -0.170705 -0.85251,
         -0.14521 -0.105502 -0.85251,
         -0.14521 0.105501 -0.85251,
         0.0554656 0.170705 -0.85251,
         0.17949 0.0 -0.17949,
         0.0554655 -0.170705 -0.17949,
         -0.14521 -0.105502 -0.17949,
         -0.14521 0.105501 -0.17949,
         0.0554655 0.170705 -0.17949,
         0.126919 0.0 -0.0525715,
         0.03922 -0.120707 -0.0525714,
         -0.102679 -0.0746009 -0.0525714,
         -0.102679 0.0746008 -0.0525714,
         0.03922 0.120707 -0.0525715,
         0.0 0.0 0.0,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="Bip01_Pelvis01">
   <mass>10.0</mass>
   <orientation>0.0621958 0.0625464 -0.704324 0.704378</orientation>
   <position>0.000236454 0.0461291 0.799724</position>
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
  <rigidbody id="Bip01_Neck01">
   <mass>10.0</mass>
   <orientation>0.0625613 0.0626317 -0.704704 0.703957</orientation>
   <position>0.000237281 -0.0639653 1.41737</position>
   <shape id="shape_Bip01_Neck01">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="Bip01_Neck01_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.25</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="Bip01_Neck01_geom">
     <capsule>
      <p0>0.0 0.0 0.151551</p0>
      <p1>0.0 0.0 0.392452</p1>
      <radius>0.151551</radius>
     </capsule>
    </geometry>
   </shape>
  </rigidbody>
  <rigidbody id="B">
   <mass>10.0</mass>
   <orientation>-0.393182 -0.393164 -0.58772 0.587721</orientation>
   <position>5.29727e-005 -0.0559826 0.955851</position>
   <shape id="shape_B">
    <orientation>0.0 0.0 0.0 1.0</orientation>
    <physicsmaterial id="B_mat">
     <dynamicfriction>0.4</dynamicfriction>
     <restitution>0.65</restitution>
     <staticfriction>0.4</staticfriction>
    </physicsmaterial>
    <geometry id="B_geom">
     <convex facecount="0">
      <vertices count="18">
         -0.395633 0.0 0.0,
         -0.343112 0.0 0.126797,
         -0.343112 0.126797 0.0,
         -0.343112 0.0 -0.126797,
         -0.343112 -0.126797 0.0,
         -0.216315 0.0 0.179318,
         -0.216315 0.179318 0.0,
         -0.216315 0.0 -0.179318,
         -0.216315 -0.179318 0.0,
         -0.179318 0.0 0.179318,
         -0.179318 0.179318 0.0,
         -0.179318 0.0 -0.179318,
         -0.179318 -0.179318 0.0,
         -0.0525211 0.0 0.126797,
         -0.0525211 0.126797 0.0,
         -0.0525211 0.0 -0.126797,
         -0.0525211 -0.126797 0.0,
         0.0 0.0 0.0,
      </vertices>
     </convex>
    </geometry>
   </shape>
  </rigidbody>
  <joint child="#Bip01_L_Thigh02" class="novodex" id="Joint_Bip01_L_Thigh02" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.911682 0.0242729 -0.410179</x>
    <y>-0.0435108 -0.998344 0.0376306</y>
    <z>-0.408587 0.0521544 0.911228</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.000253887 -0.183578 -0.105801</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 12.5288</rotlimitmax>
   <rotlimitmin>0.0 0.0 -14.0362</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf02" class="novodex" id="Joint_Bip01_L_Calf02" parent="#Bip01_L_Thigh02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.871217 -0.0283839 -0.490078</x>
    <y>0.0838411 0.992262 0.0915762</y>
    <z>0.483686 -0.120871 0.866855</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0144118 0.00645522 -0.331101</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>12.8435 73.9446 20.2839</rotlimitmax>
   <rotlimitmin>-12.8435 -73.9446 -2.62224</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Thigh01" class="novodex" id="Joint_Bip01_L_Thigh01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.912495 0.00878993 0.408994</x>
    <y>-0.00994153 -0.998997 0.0436503</y>
    <z>0.408967 -0.0438967 -0.911493</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.000258772 0.180882 -0.105796</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 16.6992</rotlimitmax>
   <rotlimitmin>0.0 0.0 -21.8014</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Calf01" class="novodex" id="Joint_Bip01_L_Calf01" parent="#Bip01_L_Thigh01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.871211 -0.0283803 -0.490088</x>
    <y>0.0838405 0.992262 0.0915796</y>
    <z>0.483697 -0.120874 0.866849</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0144117 -0.00645505 0.331101</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>80.9334 84.6801 89.5023</rotlimitmax>
   <rotlimitmin>-80.9334 -84.6801 -0.61205</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm01" class="novodex" id="Joint_Bip01_L_UpperArm01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>-0.770979 0.622545 -0.13427</x>
    <y>0.511792 0.731121 0.451144</y>
    <z>0.379025 0.279105 -0.882293</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0452207 0.217592 0.524363</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 36.0274</rotlimitmax>
   <rotlimitmin>0.0 0.0 -102.093</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm01" class="novodex" id="Joint_Bip01_L_Forearm01" parent="#Bip01_L_UpperArm01">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.756613 0.196434 -0.623659</x>
    <y>3.58978e-007 0.953807 0.300421</y>
    <z>0.653863 -0.227303 0.721662</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0 0.0 0.335516</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 74.7449</rotlimitmax>
   <rotlimitmin>0.0 0.0 -90.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_UpperArm02" class="novodex" id="Joint_Bip01_L_UpperArm02" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.882558 -0.398661 0.249322</x>
    <y>0.0620874 0.624403 0.778631</y>
    <z>-0.466087 -0.671707 0.575824</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.0452266 -0.218001 0.524357</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 80.1641</rotlimitmax>
   <rotlimitmin>0.0 0.0 -35.5983</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_L_Forearm02" class="novodex" id="Joint_Bip01_L_Forearm02" parent="#Bip01_L_UpperArm02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.771987 0.146299 -0.618573</x>
    <y>-0.481269 0.770241 -0.41846</y>
    <z>0.41523 0.620746 0.665026</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>2.37408e-007 0.0 -0.335516</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 99.4623</rotlimitmax>
   <rotlimitmin>0.0 0.0 -107.103</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Pelvis01" class="novodex" id="Joint_Bip01_Pelvis01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>1.0 -2.48158e-005 -0.000630065</x>
    <y>2.51214e-005 1.0 0.000485031</y>
    <z>0.000630053 -0.000485047 1.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.000243973 1.29819e-006 -0.0901775</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 0.0</rotlimitmax>
   <rotlimitmin>0.0 0.0 0.0</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#Bip01_Neck01" class="novodex" id="Joint_Bip01_Neck01" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.999999 0.00106764 1.00029e-005</x>
    <y>-0.00106764 0.999999 -1.00006e-005</y>
    <z>-1.00136e-005 9.98993e-006 1.0</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>-0.000305113 -7.74596e-006 0.537201</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>0.0 0.0 37.5686</rotlimitmax>
   <rotlimitmin>0.0 0.0 -30.9638</rotlimitmin>
   <Spring>0</Spring>
  </joint>
  <joint child="#B" class="novodex" id="Joint_B" parent="#Bip01_Spine02">
   <bodycollide>0</bodycollide>
   <childplacement frame="child" setforbody="child">
    <offset>0.0 0.0 0.0</offset>
    <x>0.212684 2.45229e-005 -0.977121</x>
    <y>-2.16185e-006 1.0 2.46265e-005</y>
    <z>0.977121 -3.12529e-006 0.212684</z>
   </childplacement>
   <parentplacement frame="parent" setforbody="parent">
    <offset>0.0732232 -0.000185422 0.0815102</offset>
    <x>1.0 0.0 0.0</x>
    <y>0.0 1.0 0.0</y>
    <z>0.0 0.0 1.0</z>
   </parentplacement>
   <rotlimitmax>26.5651 29.7449 33.6901</rotlimitmax>
   <rotlimitmin>-26.5651 -29.7449 -29.7449</rotlimitmin>
   <Spring>0</Spring>
  </joint>
 </physicsmodel>
</library>
