// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BG"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
					float2 voronoihash4( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi4( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash4( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						 //		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash5( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi5( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash5( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 //		if( d<F1 ) {
						 //			F2 = F1;
						 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
						 //		} else if( d<F2 ) {
						 //			F2 = d;
						 //		}
						 	}
						}
						return F1;
					}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float time4 = 6.94;
				float voronoiSmooth0 = 0.0;
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float cos7 = cos( 91.04 );
				float sin7 = sin( 91.04 );
				float2 rotator7 = mul( texCoord2 - float2( 0.5,0.5 ) , float2x2( cos7 , -sin7 , sin7 , cos7 )) + float2( 0.5,0.5 );
				float2 CenteredUV15_g1 = ( rotator7 - float2( 0.5,0.5 ) );
				float2 break17_g1 = CenteredUV15_g1;
				float2 appendResult23_g1 = (float2(( length( CenteredUV15_g1 ) * 1.0 * 2.0 ) , ( atan2( break17_g1.x , break17_g1.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				float mulTime14 = _Time.y * -1.0;
				float temp_output_21_0 = ( mulTime14 * 0.005 );
				float2 appendResult11 = (float2(( mulTime14 * 0.5 ) , temp_output_21_0));
				float2 coords4 = (appendResult23_g1*1.0 + appendResult11) * 6.15;
				float2 id4 = 0;
				float2 uv4 = 0;
				float fade4 = 0.5;
				float voroi4 = 0;
				float rest4 = 0;
				for( int it4 = 0; it4 <2; it4++ ){
				voroi4 += fade4 * voronoi4( coords4, time4, id4, uv4, voronoiSmooth0 );
				rest4 += fade4;
				coords4 *= 2;
				fade4 *= 0.5;
				}//Voronoi4
				voroi4 /= rest4;
				float time5 = 6.94;
				float2 CenteredUV15_g2 = ( i.ase_texcoord1.xy - float2( 0.5,0.5 ) );
				float2 break17_g2 = CenteredUV15_g2;
				float2 appendResult23_g2 = (float2(( length( CenteredUV15_g2 ) * 1.0 * 2.0 ) , ( atan2( break17_g2.x , break17_g2.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
				float mulTime16 = _Time.y * -1.0;
				float2 appendResult18 = (float2(( mulTime16 * 0.5 ) , temp_output_21_0));
				float2 coords5 = (appendResult23_g2*1.0 + appendResult18) * 6.15;
				float2 id5 = 0;
				float2 uv5 = 0;
				float fade5 = 0.5;
				float voroi5 = 0;
				float rest5 = 0;
				for( int it5 = 0; it5 <2; it5++ ){
				voroi5 += fade5 * voronoi5( coords5, time5, id5, uv5, voronoiSmooth0 );
				rest5 += fade5;
				coords5 *= 2;
				fade5 *= 0.5;
				}//Voronoi5
				voroi5 /= rest5;
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float lerpResult19 = lerp( voroi4 , voroi5 , tex2D( _TextureSample1, uv_TextureSample1 ).r);
				float smoothstepResult25 = smoothstep( 0.62 , 0.41 , length( (float2( -1,-1 ) + (texCoord2 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 ))) ));
				float4 appendResult22 = (float4(lerpResult19 , lerpResult19 , lerpResult19 , smoothstepResult25));
				
				
				finalColor = ( appendResult22 * i.ase_color );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
290;110;1920;1020;996.0687;609.4025;1.83031;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;14;-656.3783,-50.61969;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-936.8253,-96.62521;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;91.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-603.896,360.0488;Inherit;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1437.594,-352.7745;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-465.3783,-117.6197;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-412.896,375.0488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-393.7843,25.64603;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;7;-751.62,-249.7847;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-250.343,355.0433;Inherit;False;FLOAT2;4;0;FLOAT;47.1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;6;-593.7401,98.05268;Inherit;True;Polar Coordinates;-1;;2;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;3;-521.5,-293.6251;Inherit;True;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-261.8253,-55.62524;Inherit;False;FLOAT2;4;0;FLOAT;47.1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-963.4677,-462.5593;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;9;-176.8253,-253.6252;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;10;-109.8253,81.37479;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;4;91.82996,-257.77;Inherit;True;0;0;1;0;2;False;1;False;True;4;0;FLOAT2;0,0;False;1;FLOAT;6.94;False;2;FLOAT;6.15;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;5;106.5899,65.9075;Inherit;True;0;0;1;0;2;False;1;False;True;4;0;FLOAT2;0,0;False;1;FLOAT;6.94;False;2;FLOAT;6.15;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SamplerNode;20;229.6217,391.3803;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;2bb84cb13c376734b9efc90ba153bb8a;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;23;-707.4677,-521.5593;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;25;-414.9016,-536.364;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.62;False;2;FLOAT;0.41;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;511.0218,-49.11967;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;28;929.803,2.239638;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;922.8764,-214.2503;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1161.575,-108.5087;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1376.688,-296.633;Float;False;True;-1;2;ASEMaterialInspector;100;1;BG;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;2;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;15;0;14;0
WireConnection;17;0;16;0
WireConnection;21;0;14;0
WireConnection;7;0;2;0
WireConnection;7;2;8;0
WireConnection;18;0;17;0
WireConnection;18;1;21;0
WireConnection;3;1;7;0
WireConnection;11;0;15;0
WireConnection;11;1;21;0
WireConnection;24;0;2;0
WireConnection;9;0;3;0
WireConnection;9;2;11;0
WireConnection;10;0;6;0
WireConnection;10;2;18;0
WireConnection;4;0;9;0
WireConnection;5;0;10;0
WireConnection;23;0;24;0
WireConnection;25;0;23;0
WireConnection;19;0;4;0
WireConnection;19;1;5;0
WireConnection;19;2;20;0
WireConnection;22;0;19;0
WireConnection;22;1;19;0
WireConnection;22;2;19;0
WireConnection;22;3;25;0
WireConnection;29;0;22;0
WireConnection;29;1;28;0
WireConnection;1;0;29;0
ASEEND*/
//CHKSM=C743A14007346A409FC5A6B377A756305F6C2191