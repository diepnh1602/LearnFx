// Made with Amplify Shader Editor v1.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hai/Partcles/SwordSlash"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Main("Main", 2D) = "white" {}
		_Opacity("Opacity", Float) = 20
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector1("Vector 1", Vector) = (0,0,0,0)
		_EmisstionTex("Emisstion Tex", 2D) = "white" {}
		_Emission("Emission", Float) = 2
		_Color0("Color 0", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float4 ase_texcoord1 : TEXCOORD1;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform float4 _Color0;
				uniform sampler2D _EmisstionTex;
				uniform float4 _EmisstionTex_ST;
				uniform float _Emission;
				uniform sampler2D _Main;
				uniform float4 _Main_ST;
				uniform float _Opacity;
				uniform sampler2D _TextureSample0;
				uniform float4 _Vector1;


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.ase_texcoord3 = v.ase_texcoord1;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 uv_EmisstionTex = i.texcoord.xy * _EmisstionTex_ST.xy + _EmisstionTex_ST.zw;
					float4 _Vector2 = float4(-0.3,1,-2,1);
					float4 temp_cast_0 = (_Vector2.x).xxxx;
					float4 temp_cast_1 = (_Vector2.y).xxxx;
					float4 temp_cast_2 = (_Vector2.z).xxxx;
					float4 temp_cast_3 = (_Vector2.w).xxxx;
					float4 clampResult40 = clamp( (temp_cast_2 + (tex2D( _EmisstionTex, uv_EmisstionTex ) - temp_cast_0) * (temp_cast_3 - temp_cast_2) / (temp_cast_1 - temp_cast_0)) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
					float2 uv_Main = i.texcoord.xy * _Main_ST.xy + _Main_ST.zw;
					float clampResult5 = clamp( ( tex2D( _Main, uv_Main ).a * _Opacity ) , 0.0 , 1.0 );
					float2 appendResult27 = (float2(_Vector1.z , _Vector1.w));
					float4 texCoord21 = i.texcoord;
					texCoord21.xy = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float2 panner29 = ( 1.0 * _Time.y * appendResult27 + texCoord21.xy);
					float2 break33 = (panner29).xy;
					float4 texCoord36 = i.ase_texcoord3;
					texCoord36.xy = i.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
					float2 appendResult34 = (float2(break33.x , ( texCoord36.w + break33.y )));
					float T23 = texCoord21.w;
					float W22 = texCoord21.z;
					float3 _Vector0 = float3(0.3,0,1);
					float ifLocalVar18 = 0;
					if( ( tex2D( _TextureSample0, appendResult34 ).r * T23 ) >= W22 )
					ifLocalVar18 = _Vector0.y;
					else
					ifLocalVar18 = _Vector0.z;
					float4 appendResult6 = (float4(( ( _Color0 * i.color ) + ( clampResult40 * _Emission * i.color ) ).rgb , ( i.color.a * clampResult5 * ifLocalVar18 )));
					

					fixed4 col = appendResult6;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19100
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-212.7641,513.5164;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;18;142.0144,554.4745;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-813.9412,511.0079;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;1eae6143ce30e2849b37136524e197f0;d2d212ea9b69a8345bd6b7debdf07fcd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;20;-170.8459,816.7593;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0.3,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;25;-479.6535,850.4216;Inherit;False;22;W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-541.4316,713.1921;Inherit;False;23;T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-149.3691,-362.2232;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;404.4324,-806.389;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;43;119.1917,-825.3417;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.05467844,0.0561765,0.191,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;6;1249.158,-272.4537;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1434.375,-269.8026;Float;False;True;-1;2;ASEMaterialInspector;0;11;Hai/Partcles/SwordSlash;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.Vector4Node;39;-521.3041,-304.9837;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;0;False;0;False;-0.3,1,-2,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;859.2571,-515.7158;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;650.1834,-430.0602;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;40;50.1246,-517.22;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;313.2762,-384.7158;Inherit;False;Property;_Emission;Emission;5;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;57.14761,-306.2358;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;516.2022,26.61621;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;5;129.6799,42.25752;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-315.5306,100.9799;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-60.73024,42.47964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-464.4299,-89.82031;Inherit;True;Property;_Main;Main;0;0;Create;True;0;0;0;False;0;False;-1;None;c8ada4fdced7c07409542d983b96835e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;26;-3400.97,228.5576;Inherit;False;Property;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,1,0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;31;-1659.974,636.6323;Inherit;False;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;33;-1421.542,563.6423;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1289.423,677.9612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1147.321,544.2172;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-810.7448,-467.7993;Inherit;True;Property;_EmisstionTex;Emisstion Tex;4;0;Create;True;0;0;0;False;0;False;-1;None;776495090b22ebc49af55b62923f4a68;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;27;-2803.243,702.9288;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-2365.107,424.3429;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1584.231,743.0864;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2633.38,476.9997;Inherit;False;T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-2605.06,304.4697;Inherit;False;W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2934.506,317.5057;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;17;0;16;1
WireConnection;17;1;24;0
WireConnection;18;0;17;0
WireConnection;18;1;25;0
WireConnection;18;2;20;2
WireConnection;18;3;20;2
WireConnection;18;4;20;3
WireConnection;16;1;34;0
WireConnection;38;0;37;0
WireConnection;38;1;39;1
WireConnection;38;2;39;2
WireConnection;38;3;39;3
WireConnection;38;4;39;4
WireConnection;45;0;43;0
WireConnection;45;1;8;0
WireConnection;6;0;44;0
WireConnection;6;3;7;0
WireConnection;1;0;6;0
WireConnection;44;0;45;0
WireConnection;44;1;41;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;41;2;8;0
WireConnection;40;0;38;0
WireConnection;7;0;8;4
WireConnection;7;1;5;0
WireConnection;7;2;18;0
WireConnection;5;0;3;0
WireConnection;3;0;2;4
WireConnection;3;1;4;0
WireConnection;31;0;29;0
WireConnection;33;0;31;0
WireConnection;35;0;36;4
WireConnection;35;1;33;1
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;27;0;26;3
WireConnection;27;1;26;4
WireConnection;29;0;21;0
WireConnection;29;2;27;0
WireConnection;23;0;21;4
WireConnection;22;0;21;3
ASEEND*/
//CHKSM=D2CCF8C6EFE3DB19312671F8F5154B7232385149