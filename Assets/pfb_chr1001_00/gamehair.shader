Shader "Unlit/gamehair"
{
    Properties
    {
        _LightMain("lightmain",2D)="White"{}
        _DarkMain("darkmain",2D)="White"{}
        _RimTex("rimtex",2D)="white"{}
        _FoldTex("foldtex",2D)="white"{}
        _MatCab("matcab",2D)="white"{}

        _ToonStep("toonstep",float)=0.1
        _ToonFeather("toonfeather",float)=0.1
        _RimStep("rimstep",float)=0.1
        _RimFeather("rimfeather",float)=0.1
        _ShadowRate("shadowrate",range(0,1))=0

        _NormalOffset("normaloffset",range(0,1))=0
        _DiffuseLight("diffuselight",color)=(0.2,0.2,0.2,0.2)
        _MetalColor("metalcolor",color)=(0.1,0.1,0.1,0.1)
        _DiffuseRate("diffuserate",range(0,1))=0.9
        _DiffusePow("diffusepow",range(0.01,1))=0.5
        _DiffuseOffset("diffuseoffset",range(0.01,0.499))=0.1
        _MetalRate("metalrate",range(0,1))=0.2

        _RimHOffset1("rimhoffset1",range(-1,1))=0
        _RimVOffset1("rimvoffset1",range(-1,1))=0
        _RimHOffset1("rimhoffset2",range(-1,1))=0
        _RimVOffset1("rimvoffset2",range(-1,1))=0
        _SpecularPower("specularpower",range(1,20))=1
        _SpecularCorrection("specularcorrection",range(0,2))=0
        _SpecularRate("specularrate",range(0,1))=0
        _ColorRate("colorrate",range(0,1))=0
        _RimColor("rimcolor",color)=(0.2,0.2,0.2,0.2)
        _RimRate("rimrate",range(0,1))=0.2
        _SpecularColor("specular",color)=(0.3,0.3,0.3,0.3)
        _SpecularRate("specularrate",range(0,1))=0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal :NORMAL;
                float4 color:COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal:NORMAL;
                float4 color:COLOR;
                float4 worldvertex:TEXCOORD2;
                float3 worldnormal:TEXCOORD3;
                float3 viewnormal:TEXCOORD4;
            };
            float4 _LightColor0;

            sampler2D _LightMain;
            float4 _LightMain_ST;
            sampler2D _DarkMain;
            float4 _DarkMain_ST;
            sampler2D _RimTex;
            float4 _RimTex_ST;
            sampler2D _FoldTex;
            float4 _FoldTex_ST;
            sampler2D _MatCab;
            float4 _MatCab_ST;

            float _NormalOffset;
            float4 _DiffuseLight;
            float _DiffuseRate;
            float _DiffusePow;
            float _DiffuseOffset;
            float _MetalRate;
            float4 _MetalColor;

            float _ToonStep;
            float _ToonFeather;
            float _ColorRate;
            float _RimStep;
            float _RimFeather;
            float _ShadowRate;
            
            float _RimHOffset1;
            float _RimVOffset1;
            float _RimHOffset2;
            float _RimVOffset2;
            float _SpecularPower;
            float _SpecularCorrection;
            float4 _RimColor;
            float _RimRate;
            float4 _SpecularColor;
            float _SpecularRate;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _LightMain);
                o.normal=v.normal;
                float3 lerpnormal=lerp(v.normal.xzy,float3(v.vertex.xz,0),_NormalOffset);
                o.worldnormal=UnityObjectToWorldNormal(lerpnormal.xzy);
                o.viewnormal=mul(UNITY_MATRIX_IT_MV,lerpnormal.xzy);
                o.worldvertex=mul((float4x4)unity_ObjectToWorld,v.vertex);
                o.color=v.color;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            
           float ZeroStep(float x)
            {
                return (x>=0)-(x<0);
            }

            float3 OffsetVector(float3 origionvector,float3 aimvector,float offsetvalue)
            {
                return  lerp(origionvector,aimvector*(ZeroStep(offsetvalue)),abs(offsetvalue));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                //return i.color.w;
                float4 lighttex=tex2D(_LightMain,i.uv);
                float4 darktex=tex2D(_DarkMain,i.uv);
                float4 rimtex=tex2D(_RimTex,i.uv);
                float4 foldtex=tex2D(_FoldTex,i.uv);
                //return lighttex;
                //return darktex;
                //return rimtex.y;
                //return foldtex.y;
                //return foldtex.x;
                float4 matcabtex=tex2D(_MatCab,(i.viewnormal+float2(1,1))*0.5);//因为法线的观察者的方向的x轴与y轴的值域分别为(-1,1)而matcab贴图对应的uv的x轴和y轴的方向分别为(0,1)为了贴图空间同意到相同的空间下，需要做类似半lambert的操作
                //return matcabtex;
                float lambert=dot(normalize(_WorldSpaceLightPos0),normalize(i.worldnormal));
                float halflambert=lambert*0.5+0.5;
                float newlmabert = saturate(1+(_ToonStep-_ToonFeather-halflambert)/_ToonFeather)*(_ToonFeather>0);
                //return lighttex;
                float4 newdiffusecolor=lerp(lighttex,darktex,newlmabert);
                newdiffusecolor=newdiffusecolor*(foldtex.x*_DiffuseRate+foldtex.y*_MetalRate+foldtex.z*_ColorRate);
                //return newlmabert;
                //return newdiffusecolor*_DiffuseRate+foldtex.y*_MetalRate*_MetalColor;
                //return foldtex.y;
                //return newdiffusecolor*(foldtex.x*_DiffuseRate+foldtex.y*_MetalRate+foldtex.z*_ColorRate);

                float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
                float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
                float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
                float3 offsetviewdir1=OffsetVector(viewdir,camxdir,_RimHOffset1);
                offsetviewdir1=OffsetVector(offsetviewdir1,camydir,_RimVOffset1);
                float fresnel1=dot(offsetviewdir1,i.worldnormal);
                float fresnel1factor=saturate(1+(_RimStep-_RimFeather-fresnel1)/_RimFeather);
                //return fresnel1factor;
                fresnel1factor=pow(fresnel1factor,3)*_RimColor.w*rimtex.z;
                float4 rimcolor1 = fresnel1factor*_RimColor*(max(lambert,0)+_ShadowRate);
                float3 offsetviewdir2=OffsetVector(viewdir,camxdir,_RimHOffset2);
                offsetviewdir2=OffsetVector(offsetviewdir2,camydir,_RimVOffset2);
                float fresnel2=dot(offsetviewdir2,i.worldnormal);
                float fresnel2factor=saturate(1+(_RimStep-_RimFeather-fresnel2)/_RimFeather);
                fresnel2factor=pow(fresnel2factor,3)*_RimColor.w*rimtex.z;
                float4 rimcolor2=fresnel2factor*_RimColor*(max(lambert,0)+_ShadowRate);

                float4 specularcolor=rimtex.y*matcabtex*_SpecularColor*_SpecularRate;
                //return newdiffusecolor;
                return newdiffusecolor+rimcolor1+specularcolor;
                //fresnel2fa


                // float lambertfactor=(lambert*0.5+0.5)*foldtex.x;
                // lambertfactor=lambertfactor*2-1;
                // lambertfactor=0.5*(ZeroStep(lambertfactor)*pow(abs(lambertfactor),_DiffusePow)+1);
                // float4 diffusecolor=lerp(darktex,lighttex, smoothstep(0.5-_DiffuseOffset,0.5+_DiffuseOffset,lambertfactor));
                // //return diffusecolor;
                // // return lambertfactor>0.5;
                // // float4 diffusecolor=lighttex*(lambertfactor>0.5)+darktex*(lambertfactor<=0.5);
                // diffusecolor=diffusecolor*(_DiffuseLight*_DiffuseRate+foldtex.y*_MetalRate*_MetalColor);
                // //return foldtex.y;
                // //return diffusecolor;
                // //float4 diffusecolor=darktex*(lambert<0)+lighttex*(lambert>=0);
                // float3 viewdir=normalize(_WorldSpaceCameraPos.xyz-i.worldvertex.xyz);
                // float3 camxdir=float3(UNITY_MATRIX_V[0].x,UNITY_MATRIX_V[1].x,UNITY_MATRIX_V[2].x);
                // float3 camydir=float3(UNITY_MATRIX_V[0].y,UNITY_MATRIX_V[1].y,UNITY_MATRIX_V[2].y);
                // viewdir=lerp(viewdir,camxdir*((_RimHOffset>0)-(_RimHOffset<=0)),abs(_RimHOffset));
                // viewdir=lerp(viewdir,camydir*((_RimVOffset>0)-(_RimVOffset<=0)),abs(_RimVOffset));
                // float fresnel=pow(saturate(_SpecularCorrection-dot(viewdir,i.worldnormal)),_SpecularPower);
                // //return fresnel;
                // float4 specularcolor=float4(0,0,0,1);
                // //specularcolor.xyz=matcabtex.xyz*foldtex.y*_SpecularColor.xyz*_SpecularRate;
                // specularcolor.xyz=rimtex.y*_SpecularColor.xyz*lerp(float3(_SpecularRate,_SpecularRate,_SpecularRate),matcabtex.xyz,rimtex.y)*(1-abs(i.viewnormal.x));
                // //return specularcolor+diffusecolor;
                // float4 finalcolor=float4(0,0,0,1);
                // //return float4(fresnel*_RimColor.xyz*_RimRate,1);
                // //finalcolor.xyz=fresnel*_RimColor.xyz*_RimRate+specularcolor.xyz+diffusecolor.xyz;
                // finalcolor.xyz=fresnel*_RimColor.xyz*_RimRate+specularcolor.xyz+newdiffusecolor.xyz;
                // return finalcolor;
            }
            ENDCG
        }
    }
}
