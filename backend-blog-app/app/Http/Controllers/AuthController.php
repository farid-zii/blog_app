<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Validator;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function register(Request $r)
    {
        $validate = Validator::make($r->all(),[
            'name'=>'required|string',
            'email'=>'required|email|unique:users,email',
            'password'=>"required|min:6|confirmed"
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $user=User::create([
            "name"=>$r->name,
            "password"=>bcrypt($r->password),
            "email"=>$r->email
        ]);

        //
        return response([
            'user'=>$user,
            'token'=>$user->createToken('secret')->plainTextToken
        ],200);
    }

    public function login(Request $r)
    {
        $validate = Validator::make($r->all(),[
            'email'=>'required|email',
            'password'=>"required|min:6"
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $credential =[
            "email"=>$r->email,
            "password"=>$r->password
        ];

        //cek apakah data sesuai dengan database
        if(!Auth::attempt($credential)){

            return response([
                'msg'=>"Invalid Login Try Again"
            ],403);
        }

        //
        return response([
            'user'=>auth()->user(),
            'token'=>auth()->user()->createToken('secret')->plainTextToken
        ]);
    }

    public function logout(){
        auth()->user()->tokens()->delete();
        return response([
            "msg"=>"Logout Successs"
        ],200);
    }

    //Mendapatkan data yang login
    public function user(){
        return response([
            'user'=>auth()->user(),
        ]);
    }


}
