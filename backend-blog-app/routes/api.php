<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\LikeController;
use App\Http\Controllers\PostController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/register', [AuthController::class,'register']);
Route::post('/login', [AuthController::class,'login']);
// Route::get('/user', [AuthController::class,'user']);


Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/user', [AuthController::class,'user']);
    Route::post('/logout', [AuthController::class,'logout']);


    // Posts
    Route::resource('/post',PostController::class);

    // Comments

    Route::get("/post/{id}/comments",[CommentController::class,'index']);
    Route::post("/post/{id}/comments",[CommentController::class,'store']);
    Route::put("/comments/{id}",[CommentController::class,'update']);
    Route::delete("/comments/{id}",[CommentController::class,'destroy']);

    //Like
    Route::post("/post/{id}",[LikeController::class,'update']);
});
